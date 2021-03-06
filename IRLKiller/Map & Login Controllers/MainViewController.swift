import UIKit
import FirebaseUI
import FirebaseDatabase
import Mapbox
import Firebase
import MapKit
import CoreLocation

class MainViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    // Map standart attributes
    var basicLocation = CLLocationCoordinate2D (latitude: 48.8582573, longitude: 2.2945111)
    let altitude: CLLocationDistance = 500
    let pitch: CGFloat = 30
    let heading: CLLocationDirection = 180

    // Managers
    let locationManager = CLLocationManager()
    let TC = TimeConverter()
    let defaults = UserDefaults.standard

    // Class
    class MyCustomPointAnnotation: MGLPointAnnotation {
        var typeOfImage: String = "online"
    }

    // Arrays
    var players = [String : Player]()
    var annotationsPlayers = [String : MGLAnnotation]()

    // Player attributes
    var myLogin = ""
    var myRating = 0 {
        didSet {
             DataBaseManager.myRating = myRating
        }
    }
    var myHealth = 100 {
        didSet {
            if myHealth > 0 {
                healthProgress.isHidden = false
                healthProgress.progress = Float(myHealth) / 100.0
                healthText.text = String(myHealth) + " HP"}
            else {
                healthProgress.isHidden = true
                healthText.text = ""
            }
        }
    }
    var timeOfDeath = ""
    var isAlive = true
    var userUID: String?
    var userLocation: CLLocationCoordinate2D {
        get { return mapView.userLocation?.coordinate ?? basicLocation }
    }

    // Keys and flags
    let lastShotTimeKey = "TimeOfLastShot"
    var hasConnection = true
    var screenIsAlredyShown = false
    var rebornScreenIsShown = false

    // View and buttons
    @IBOutlet weak var healthProgress: UIProgressView!
    @IBOutlet weak var healthText: UILabel!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    private var loadingAnimationView: LoadingAnimationView!

    // Functions which connected to actions
    @IBAction func clickMyLocation(_ sender: Any) {
        showMyLocation()
    }

    // For testing!
    @IBAction func logoutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
    }

    func showPrivacyAlert(){
        let alert = UIAlertController(title: "Please allow geolocation access to use the app", message: "Settings-> Privacy->Location Services-> IRLKiller-> While using the app. Then RESTART the app", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.checkLocationServices()
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            checkLocationAuthorization()
        } else {
            showPrivacyAlert()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            showPrivacyAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    private func setupLoadingAnimationView() {
        if (loadingAnimationView == nil) {
            loadingAnimationView = LoadingAnimationView(frame: view.bounds)
        }
        view.addSubview(loadingAnimationView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        checkLocationServices()
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .none, object: nil)

        checkInternetConnection()
    }
    


    override func viewWillAppear(_ animated: Bool) {
        // screenIsAlredyShown = становится true когда карта appear первый раз чтобы когда карта appear при переключении на tabbar вкладках не делалось viewDidAppear второй раз


        guard let user = Auth.auth().currentUser else {
            print("User not created")
            return
        }

        if screenIsAlredyShown {
            print("Screen is shown")
            return
        }

        screenIsAlredyShown = true
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        healthProgress.transform = transform
        setupLoadingAnimationView()

        userUID = user.uid
        guard let ref = DataBaseManager.shared.refToUser else { print("User not created"); return }

        //чтение логина из БД
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = snapshot.value as? [String : AnyObject] {
                self.myLogin = user["login"] as! String
                DataBaseManager.myLogin = self.myLogin
                self.myRating = user["rating"] as! Int
                DataBaseManager.myRating = self.myRating
                self.myHealth = user["health"] as! Int
                print(self.myLogin)
                self.loginText.text = self.myLogin
                let offlinePosX = user["latitude"] as! Double
                let offlinePosY = user["longitude"] as! Double

                self.timeOfDeath = user[DatabaseKeys.time_death.rawValue] as! String
                self.checkRebirth()

                self.basicLocation = CLLocationCoordinate2D(
                    latitude: offlinePosX,
                    longitude: offlinePosY
                )

                let camera = MGLMapCamera(
                    lookingAtCenter: self.userLocation,
                    altitude: self.altitude, pitch: self.pitch, heading: self.heading
                )
                self.mapView.setCamera(camera, animated: false)
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in self.loadingAnimationView.removeFromSuperview() } )
            }})

        setupMapView()
        setupDataBaseTranslation()
    }

    func setupDataBaseTranslation() {

        // Ставим обновление базы данных каждые 5 секунд
        let _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateDB), userInfo: nil, repeats: true)

        let refToUsers = DataBaseManager.Refs.databaseUsers

        // Вызывается автоматически, когда изменяется какое либо значение у чела и отрисовывает его местопложение
        refToUsers.observe(.childChanged) { (snapshot) in
                self.readNewData(snapshot: snapshot, isAdding: false)
        }

        //вызывается в самом начале и отрисовывает всех челов, а также когда новый чел зарегистрировался тоже вызовется автоматичеки и его отрисует
        refToUsers.observe(.childAdded) { (snapshot) in
            self.readNewData(snapshot: snapshot, isAdding: true)

        }

    }

    func readNewData(snapshot: DataSnapshot, isAdding: Bool) {
        //  print(snapshot.value as! [String: Any])
        guard let timeOnline = snapshot.childSnapshot(forPath: "time_online").value as? String else { return }
        guard let timeDeath = snapshot.childSnapshot(forPath: "time_death").value as? String   else { return }
        guard let curLogin = snapshot.childSnapshot(forPath: "login").value as? String         else { return }

        guard let posx = snapshot.childSnapshot(forPath: "latitude").value as? Double          else { return }
        guard let posy = snapshot.childSnapshot(forPath: "longitude").value as? Double         else { return }

        guard let curHealth = snapshot.childSnapshot(forPath: "health").value as? Int          else { return }
        guard let curRating = snapshot.childSnapshot(forPath: "rating").value as? Int          else { return }

        let isOnline = !TimeConverter.isMoreThanInterval(oldDate: timeOnline, interval: 1, in: .minute)

        let curPlayer = Player(
            login: curLogin,
            position: CLLocationCoordinate2D(latitude: posx, longitude: posy),
            isOnline: isOnline,
            health: curHealth,
            rating: curRating
        )

        self.players[curLogin] = curPlayer
        DataBaseManager.players[curLogin] = curPlayer

        // Drawing player on the map
        guard curLogin != myLogin else {
            let lstHealth = myHealth
            myHealth = curHealth

            // Now i am killed
            if (lstHealth > 0 && curHealth == 0) {
                timeOfDeath = timeDeath
                checkRebirth()
            }
            return
        }
        let curPoint: MyCustomPointAnnotation = {
            let annotation = MyCustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: posx, longitude: posy)
            annotation.title = curLogin
            annotation.subtitle = "AK-47  \(curHealth)HP"
            annotation.typeOfImage = isOnline ? "online" : "offline"
            return annotation
        }()

        guard curHealth > 0 else { return }
        if !isAdding {
            if let currentPoint = self.annotationsPlayers[curLogin] {
                self.mapView.removeAnnotation(currentPoint)
            }
        }
        self.mapView.addAnnotation(curPoint)
        self.annotationsPlayers[curLogin] = curPoint
    }

    // MARK: -checkInternetConnection
    func checkInternetConnection() {
        if !Reachability.isConnectedToNetwork() && hasConnection {
            showInternetAlert()
            print("Internet Connection not Available!")
        }
    }

    @objc func statusManager(_ notification: Notification) {
        checkInternetConnection()
    }


    func showInternetAlert() {
        hasConnection = false
        let alert = UIAlertController(title: "No internet connection",
                                      message: "Please connect your device to the internet.",
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: { (action: UIAlertAction!) in
                                        self.hasConnection = true
                                        self.checkInternetConnection()
        }))

        // show the alert

        self.present(alert, animated: true, completion: nil)
    }


    // MARK: - Data base work
    @objc func updateDB() {
        DispatchQueue.global(qos: .utility).async {
            guard let ref = DataBaseManager.shared.refToUser else { return }
            //Следующих двух строк не будет в продакшене,они нужны чтобы когда акк удалили не крашилось приложение на устройстве где сохранен этот акк,при вызове readNewData get пустой login
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    let location = self.userLocation
                    if (location.latitude != -180 && location.longitude != -180) {
                        let values: [DatabaseKeys: Any] = [.time_online : TimeConverter.convertToUTC(in: .minute),
                                                           .latitude        : location.latitude,
                                                           .longitude       : location.longitude]
                        DataBaseManager.shared.updateUserValues(for: self.userUID, with: values)
                    }
                } else {
                    print("ONLY IN TEST")
                    print("The account is deleted, please press test logout and rerun the app\nLOGOUT\nLOGOUT\nLOGOUT")
                }
            })
        }
    }

    @objc func checkRebirth() {
        if (myHealth == 0) {
            isAlive = false
            let rebornTime: UInt = 5 * 60
            if (TimeConverter.isMoreThanInterval(oldDate: timeOfDeath, interval: rebornTime, in: .second)) {
                guard let ref = DataBaseManager.shared.refToUser else { return }
                myHealth = 100
                ref.updateChildValues([ "health" : 100 ])
                mapView.showsUserLocation = true
                isAlive = true
            } else {
                let timeLeft = TimeConverter.showInterval(oldDate: timeOfDeath, in: .second)
                if (rebornScreenIsShown == false) {
                    view.addSubview(createDeathView(timeToReborn: rebornTime - timeLeft))
                    mapView.showsUserLocation = false
                    rebornScreenIsShown = true
                }
                print("left until rebirth ~\(rebornTime - timeLeft) sec")
                Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkRebirth), userInfo: nil, repeats: false)
            }
        }
    }

    // MARK:- Create death view
    private func createDeathView(timeToReborn: UInt) -> DeathView {
        let w = view.bounds.width
        let h = view.bounds.height - (self.tabBarController?.tabBar.frame.height ?? 0)
        let actualHeight = h / 5
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 10
        let deathView = DeathView(frame: CGRect(x: xOffset,
                                                y: h - actualHeight - 2 * yOffset,
                                                width: w - 2 * xOffset,
                                                height: actualHeight),
                                  timeToReborn: timeToReborn)
        return deathView
    }


    func setupMapView()  {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }


    func showMyLocation() {
        let cameraFocusedOnUsersLocation = MGLMapCamera(
            lookingAtCenter: userLocation,
            altitude: altitude, pitch: pitch, heading: heading
        )
        mapView.fly(to: cameraFocusedOnUsersLocation, withDuration: 2, completionHandler: nil)
    }


    // This delegate method is where you tell the map to load an image for a specific annotation based on the willUseImage property of the custom subclass.

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {

        var curType = "online"
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "online")
        // For better performance, always try to reuse existing annotations.
        if let castAnnotation = annotation as? MyCustomPointAnnotation {
            if (castAnnotation.typeOfImage == "offline") {
                annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "offline")
                curType = "offline"
            }
        }

        // If there is no reusable annotation image available, initialize a new one.
        if (annotationImage == nil) {
            switch curType {

            case "offline":
                annotationImage = MGLAnnotationImage(
                    image: UIImage(named: "enemy-offline")!,
                    reuseIdentifier: "offline")

            default:
                annotationImage = MGLAnnotationImage(
                    image: UIImage(named: "enemy-online")!,
                    reuseIdentifier: "online")
            }
        }

        return annotationImage
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }


    // MARK:- leftCalloutAccessoryViewFo
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        guard let title = annotation.title, let login = title else {
            return nil
        }
        return createLeftCalloutView(login: login)
    }

    private func createLeftCalloutView(login: String) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 42, height: 20))
        guard let player = players[login] else { return nil }
        label.textColor = UIColor.getRatingColor(for: player.rating)
        label.text = String(player.rating)
        return label
    }

    // MARK:- rightCalloutAccessoryViewFor
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        guard annotation.title != "You Are Here" else {
            return nil
        }
        return createRightCalloutView()
    }

    private func createRightCalloutView() -> UIView {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        button.backgroundColor = .black
        button.setTitle("Shoot", for: .normal)
        return button
    }

    // MARK:- Create cool downn view
    private func createCoolDownView(timeLeft: UInt) -> CoolDownNotificationView {
        let w = view.bounds.width
        let h = view.bounds.height - (self.tabBarController?.tabBar.frame.height ?? 0)
        let xOffset: CGFloat = 10
        let actualHeight = h / 3
        let view = CoolDownNotificationView(frame: CGRect(origin: CGPoint(x: xOffset, y: h - actualHeight - 10),
                                                          size: CGSize(width: w - 2 * xOffset, height: actualHeight)),
                                            timeLeft: timeLeft)
        return view
    }

    // MARK:- Create reward view
    private func createRewardView(killerPreviousRating: Int,
                                  killerCurrentRating: Int,
                                  killerLogin: String,
                                  victimPreviousRating: Int,
                                  victimCurrentRating: Int,
                                  victimLogin: String
    ) -> RewardView {
        let w = view.bounds.width
        let h = view.bounds.height - (self.tabBarController?.tabBar.frame.height ?? 0)
        let actualHeight = h / 2
        let xOffset: CGFloat = 10
        let rewardView = RewardView(frame: CGRect(x: xOffset,
                                                  y: h / 3,
                                                  width: w - 2 * xOffset,
                                                  height: h - actualHeight))

        rewardView.killerView.ratingChangeLabel.text = "Rating: \(killerPreviousRating) -> \(killerCurrentRating)"
        rewardView.victimView.ratingChangeLabel.text = "Rating: \(victimPreviousRating) -> \(victimCurrentRating)"
        rewardView.killerView.ratingChangeLabel.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        rewardView.victimView.ratingChangeLabel.textColor = .red

        rewardView.killerView.playerNameLabel.text = killerLogin
        rewardView.victimView.playerNameLabel.text = victimLogin

        return rewardView
    }

    // MARK:- Animate reward view
    private func animateViewAppearing(appearingView: UIView, mainView: UIView) {
        appearingView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        mainView.insertSubview(appearingView, aboveSubview: mainView)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { appearingView.transform = .identity },
                       completion: nil)
    }

    private func createAlertView(message: String) -> ShotAlertView {
        let w = view.bounds.width
        let h = view.bounds.height - (self.tabBarController?.tabBar.frame.height ?? 0)
        let actualHeight = h / 5
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 10
        let afterShotView = ShotAlertView(frame: CGRect(x: xOffset,
                                                        y: h - actualHeight - 2 * yOffset,
                                                        width: w - 2 * xOffset,
                                                        height: actualHeight))
        
        afterShotView.alertLabel.text = message
        return afterShotView
    }


    // Нажатие на Shoot в аннотации
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        guard isAlive else { return }

        if let oldDate = defaults.string(forKey: lastShotTimeKey) {
            let difference = TimeConverter.showInterval(oldDate: oldDate, in: .second)
            let reloadTime = WeaponModel.defaultWeapon.reloadTime
            guard difference >= reloadTime else {
                let timeLeft = reloadTime - difference
                let coolDownView = createCoolDownView(timeLeft: timeLeft)
                view.addSubview(coolDownView)
                let interval = TimeInterval(min(2, timeLeft))
                Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in coolDownView.removeFromSuperview() })
                return
            }
        }

        if let victim = players[annotation.title!!]{
            // если хватает дистанции оружия
            let distance = userLocation.distance(to: victim.position)
            let defaultWeapon: Weapon! = WeaponModel.defaultWeapon

            guard distance < CLLocationDistance(defaultWeapon.distance) else {
                let alertView = self.createAlertView(message: "Not enough distance!")
                self.view.addSubview(alertView)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in alertView.removeFromSuperview() } )
                return
            }

            mapView.deselectAnnotation(annotation, animated: false)

            let refToVictimUser = DataBaseManager.Refs.databaseUserNames.child("/\(victim.login.lowercased())")
            refToVictimUser.observeSingleEvent(of: .value, with: { (snapshot) in
                if let victimUserUID = snapshot.value as? String {

                    let changes = WeaponCalculator.getRatingAndHealthAfterShoot(killerRating: self.myRating,
                                                                                victimRating: victim.rating,
                                                                                victimHealth: victim.health,
                                                                                weaponDamage: defaultWeapon.damage)

                    if (changes.victimHealth == 0) {
                        let rewardView = self.createRewardView(killerPreviousRating: self.myRating,
                                                               killerCurrentRating: changes.killerRating,
                                                               killerLogin: self.myLogin,
                                                               victimPreviousRating: victim.rating,
                                                               victimCurrentRating: changes.victimRating,
                                                               victimLogin: victim.login)

                        self.animateViewAppearing(appearingView: rewardView, mainView: self.view)

                        if let anotation = self.annotationsPlayers[victim.login] {
                            self.mapView.removeAnnotation(anotation)
                        }
                        DispatchQueue.global(qos: .utility).async {
                            self.myRating = changes.killerRating
                            DataBaseManager.shared.updateUserValues(for: self.userUID, with: [.rating : self.myRating])
                        }
                    } else {
                        let afterShotView = self.createAlertView(message: "Nice shot!" + "\n" + "\(-defaultWeapon.damage) hp")
                        self.view.addSubview(afterShotView)
                        Timer.scheduledTimer(withTimeInterval: 3,
                                             repeats: false,
                                             block: { _ in afterShotView.removeFromSuperview() })
                    }

                    DispatchQueue.global(qos: .utility).async {
                        let values: [DatabaseKeys: Any] = [.health     : changes.victimHealth,
                                                           .rating     : changes.victimRating,
                                                           .time_death : TimeConverter.convertToUTC(in: .minute)]

                        DataBaseManager.shared.updateUserValues(for: victimUserUID, with: values)
                    }
                }
            })
            defaults.set(TimeConverter.convertToUTC(in: .second), forKey: lastShotTimeKey)
        }
    }
}
