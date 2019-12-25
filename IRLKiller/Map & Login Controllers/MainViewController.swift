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
    var myRating = 0
    var myHealth = 100
    var myKD: UInt = 10
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
    
    // View and buttons
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    private var pulsatingView: PulsatingView!
    
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
    
    private func setupDownloadView() {
        pulsatingView = PulsatingView(frame: view.bounds,
                                      radius: view.bounds.midX / 2,
                                      circleCenter: CGPoint(x: view.bounds.midX, y: view.bounds.midY),
                                      strokeColor:  UIColor.outlineStrokeColor.cgColor,
                                      pulseColor: UIColor.pulsatingFillColor.cgColor)
        
        pulsatingView.backgroundColor = UIColor.downloadViewBackgroundColor
        view.insertSubview(pulsatingView, at: Int.max)
        pulsatingView.startPulseAnimation(onePulseDuration: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        checkLocationServices()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // screenIsAlredyShown = становится true когда карта appear первый раз чтобы когда карта appear при переключении на tabbar вкладках не делалось viewDidAppear второй раз
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .none, object: nil)
        
        checkInternetConnection()
        
        guard let user = Auth.auth().currentUser else {
            print("User not created")
            return
        }
        
        if screenIsAlredyShown {
            print("Screen is shown")
            return
        }
        
        //setupDownloadView()
        
        screenIsAlredyShown = true
        userUID = user.uid
        guard let ref = DataBaseManager.shared.refToUser else { print("User not created"); return }
        
        //чтение логина из БД
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = snapshot.value as? [String : AnyObject] {
                self.myLogin = user["login"] as! String
                self.myRating = user["rating"] as! Int
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
                //                UIView.animate(withDuration: 0.4, delay: 2.0, options: .beginFromCurrentState,
                //                               animations: { self.pulsatingView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) },
                //                               completion: { (succes) in self.pulsatingView.removeFromSuperview() })
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
    
    // MARK: - function tcheckInternetConnection
    func checkInternetConnection() {
        if !Reachability.isConnectedToNetwork() && hasConnection {
            showInternetAlert()
            //print("Internet Connection not Available!")
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
            //Следующих двух строк не будет в продакшене,они нужны чтобы когда акк удалили не крашилось приложение на устройсвте где сохранен этот акк,при вызове readNewData get пустой login
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    let location = self.userLocation
                    if (location.latitude != -180 && location.longitude != -180){
                        //                        print("Data Load to DB")
                        //                        print("x = \(self.userLocation.latitude), y = \(self.userLocation.longitude)")
                        let values: [DatabaseKeys: Any] = [.time_online : TimeConverter.convertToUTC(in: .minute),
                                                           .latitude        : location.latitude,
                                                           .longitude       : location.longitude]
                        DataBaseManager.shared.updateUserValues(for: self.userUID, with: values)
                    }
                } else {
                    print("The account is deleted, please press test logout and rerun the app\nLOGOUT\nLOGOUT\nLOGOUT")
                }
            })
        }
        
    }
    
    @objc func checkRebirth(){
        if (myHealth == 0) {
            isAlive = false
            if (TimeConverter.isMoreThanInterval(oldDate: timeOfDeath, interval: 5, in: .minute)) {
                guard let ref = DataBaseManager.shared.refToUser else { return }
                ref.updateChildValues([ "health" : 100 ])
                mapView.showsUserLocation = true
                isAlive = true
            } else {
                mapView.showsUserLocation = false
                let timeLeft = TimeConverter.showInterval(oldDate: timeOfDeath, in: .minute)
                print("left until rebirth ~\(5 - timeLeft) min")
                let _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkRebirth), userInfo: nil, repeats: false)
            }
        }
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
    
    
    
    //Нажатие на Shoot в аннотации
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        
        //если живой то можешь стрелять
        guard isAlive else { return }
        
        if let oldDate = defaults.string(forKey: lastShotTimeKey) {
            guard TimeConverter.isMoreThanInterval(oldDate: oldDate, interval: myKD, in: .second) else {
                let w = view.bounds.width
                let h = view.bounds.height
                let kdView = CoolDownNotificationView(frame:
                    CGRect(origin: CGPoint(x: 0, y: h - h / 3),
                           size: CGSize(width: w, height: h / 3)
                    ))
                view.addSubview(kdView)
                Timer.scheduledTimer(withTimeInterval: TimeInterval(min(3, myKD - 1)), repeats: false) { (time) in
                    kdView.removeFromSuperview()
                }
                let delta = TimeConverter.showInterval(oldDate: oldDate, in: .second)
                print("Kd remaining : sec  \(self.myKD - delta)")
                return
            }
        }
        
        if let victim = players[annotation.title!!]{
            // если хватает дистанции оружия
            let distance = userLocation.distance(to: victim.position)
            let defaultWeapon = UserDefaults.standard.getDefaultWeapon()
            
            guard distance < CLLocationDistance(defaultWeapon.distance) else {
                print("NOT ENOUGH DISTANCE")
                return
            }
            
            mapView.deselectAnnotation(annotation, animated: false)
            
            let alert = UIAlertController(title: "Nice shot",
                                          message: "\(-defaultWeapon.damage) HP",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            let refToVictimUser = DataBaseManager.Refs.databaseUserNames.child("/\(victim.login.lowercased())")
            
            refToVictimUser.observeSingleEvent(of: .value, with: { (snapshot) in
                if let victimUserUID = snapshot.value as? String {
                    
                    let changes = WeaponCalculator.getRatingAndHealthAfterShoot(killerRating: self.myRating,
                                                                                victimRating: victim.rating,
                                                                                victimHealth: victim.health,
                                                                                weaponDamage: defaultWeapon.damage)
                    if (changes.victimHealth == 0) {
                        if let anotation = self.annotationsPlayers[victim.login] {
                            self.mapView.removeAnnotation(anotation)
                        }
                        DispatchQueue.global(qos: .utility).async {
                            self.myRating = changes.killerRating
                            DataBaseManager.shared.updateUserValues(for: self.userUID, with: [.rating : self.myRating])
                        }
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
            //можно не алерт будет сделать а всплывающее окно свое
            self.present(alert, animated: true, completion: nil)
        }
    }
}
