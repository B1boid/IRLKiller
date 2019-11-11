import UIKit
import FirebaseUI
import FirebaseDatabase
import Mapbox
import Firebase

class MainViewController: UIViewController, MGLMapViewDelegate {
    
    // Map settings
    var basicLocation = CLLocationCoordinate2D (latitude: 48.8582573, longitude: 2.2945111)
    //(latitude: 40.74699, longitude: -73.98742)
    let altitude: CLLocationDistance = 500
    let pitch: CGFloat = 30
    let heading: CLLocationDirection = 180
    
    var userID: String?
    var userLocation: CLLocationCoordinate2D {
        get { return mapView.userLocation?.coordinate ?? basicLocation }
    }
    var isNotAlreadyShown: Bool = true
    
    struct Player {
        var login: String
        var position: CLLocationCoordinate2D
        var isOnline: Bool
        var health: Int
        var rating: Int
    }
    
    class MyCustomPointAnnotation: MGLPointAnnotation {
        var typeOfImage: String = "online"
    }
    
    
    var players = [String : Player]()
    
    var annotationsPlayers = [String : MGLAnnotation]()
    
    var myLogin = ""
    var myRating = 0
    var myHealth = 100
    
    // View and buttons
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    
    // Functions which connected to actions
    @IBAction func clickMyLocation(_ sender: Any) {
        showMyLocation()
    }
    
    // Чисто для теста,в игре нельзя разлогиниться
    @IBAction func logoutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // isNotAlreadyShown = становится false когда карта appear первый раз чтобы когда карта appear при переключении на tabbar вкладках не делалось viewDidAppear второй раз
        if Auth.auth().currentUser != nil && isNotAlreadyShown {
            isNotAlreadyShown = false
            userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users/\(userID!)")
            
            let currentCamera = MGLMapCamera(
                lookingAtCenter: self.basicLocation,
                altitude: self.altitude, pitch: self.pitch, heading: self.heading
            )
            self.mapView.alpha = 0
            self.mapView.setCamera(currentCamera, animated: false)
            
            
            //чтение логина из БД
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = snapshot.value as? [String : AnyObject] {
                    self.myLogin = user["login"] as! String
                    self.myRating = user["rating"] as! Int
                    self.myHealth = user["health"] as! Int
                    print(self.myLogin)
                    self.loginText.text = self.myLogin
                    let offlinePosX = user["pos-x"] as! Double
                    let offlinePosY = user["pos-y"] as! Double
                    
                    self.basicLocation = CLLocationCoordinate2D(
                        latitude: offlinePosX,
                        longitude: offlinePosY
                    )
                    
                    let currentCamera0 = MGLMapCamera(
                        lookingAtCenter: self.userLocation,
                        altitude: self.altitude, pitch: self.pitch, heading: self.heading
                    )
                    self.mapView.fly(to: currentCamera0, withDuration: 1, completionHandler: nil)
                    UIView.animate(withDuration: 2, animations: {
                        self.mapView.alpha = 1
                    })
                }
            })
            
            setupMapView()
            setupDataBaseTranslation()
        }
    }
    
    func setupDataBaseTranslation() {
        
        // Ставим обновление базы данных каждые 5 секунд
        let _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateDB), userInfo: nil, repeats: true)
        
        let refToUsers = Database.database().reference().child("users")
        
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
        
        let isOnline = snapshot.childSnapshot(forPath: "online").value as! Bool
        let curLogin = snapshot.childSnapshot(forPath: "login").value as! String
        let posx = snapshot.childSnapshot(forPath: "pos-x").value as! Double
        let posy = snapshot.childSnapshot(forPath: "pos-y").value as! Double
        let curHealth = snapshot.childSnapshot(forPath: "health").value as! Int
        let curRating = snapshot.childSnapshot(forPath: "rating").value as! Int
        
        let curPlayer = Player(
            login: curLogin,
            position: CLLocationCoordinate2D(latitude: posx, longitude: posy),
            isOnline: isOnline,
            health: curHealth,
            rating: curRating
        )
        
        self.players[curLogin] = curPlayer
        
        print("show: \(curLogin)")
        print("x: \(posx), y: \(posy)")
        
        // тут отрисовываем чела на карте
        if curLogin != myLogin {
            let curPoint: MyCustomPointAnnotation = {
                let annotation = MyCustomPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: posx, longitude: posy)
                annotation.title = curLogin
                annotation.subtitle = "AK-47  \(curHealth)HP"
                annotation.typeOfImage = isOnline ? "online" : "offline"
                return annotation
            }()
            if curHealth > 0 {
                DispatchQueue.main.async {
                    if !isAdding {
                        if let currentPoint = self.annotationsPlayers[curLogin]{
                            self.mapView.removeAnnotation(currentPoint)
                        }
                    }
                    self.mapView.addAnnotation(curPoint)
                    self.annotationsPlayers[curLogin] = curPoint
                }
            }
        }
    }
    
    @objc func updateDB() {
        DispatchQueue.global(qos: .utility).async {
            let ref = Database.database().reference().child("users/\(self.userID!)")
            //Следующих двух строк не будет в продакшене,они нужны чтобы когда акк удалили не крашилось приложение на устройсвте где сохранен этот акк,при вызове readNewData get пустой login
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    print("Data Load to DB")
                    print("x = \(self.userLocation.latitude), y = \(self.userLocation.longitude)")
                    
                    let location = self.userLocation
                    ref.updateChildValues(
                        ["online" : true ,
                         "pos-x"  : location.latitude,
                         "pos-y"  : location.longitude])
                } else {
                    print("The account is deleted, please press test logout and rerun the app\nLOGOUT\nLOGOUT\nLOGOUT")
                }
            })
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
        if(annotationImage == nil) {
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
    
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! != "You Are Here") {
            // Callout height is fixed; width expands to fit its content.
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 42, height: 20))
            if let curPlayer = players[annotation.title!!]{
                let curRating = curPlayer.rating
                switch curRating{
                case 2000...:
                    label.textColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
                case 1800..<2000:
                    label.textColor = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
                case 1600..<1800:
                    label.textColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
                case 1400..<1600:
                    label.textColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
                case 1000..<1400:
                    label.textColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
                default:
                    label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                }
                label.text = String(curPlayer.rating)
                return label
            }
        }
        return nil
    }
    
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! != "You Are Here") {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
            button.backgroundColor = .black
            button.setTitle("Shoot", for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
            return button
        }
        
        return nil
    }
    
    //Нажатие на Shoot в аннотации
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        
        mapView.deselectAnnotation(annotation, animated: false)
        //
        //Если откатилась перезарядка
        //потом будет
        //
        //И если хватает дистанции
        //потом будет
        let alert = UIAlertController(title: "Nice shot", message: "-20 HP", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let curPlayer = players[annotation.title!!]{
            let ref = Database.database().reference().child("usernames/\(players[annotation.title!!]!.login.lowercased())")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let curID = snapshot.value as? String {
                    var curHealth = curPlayer.health - 20
                    var Rating1 = self.myRating
                    var Rating2 = curPlayer.rating
                    if curHealth <= 0{
                        curHealth = 0
                        self.mapView.removeAnnotation(self.annotationsPlayers[curPlayer.login]!)
                        let delta:Double = Double(abs(Rating1-Rating2))
                        var delta2:Double = 0
                        print(delta,"RatingsDelta")
                        switch delta {
                        case ..<100:
                            delta2 = (25 - 5*delta/100).rounded()
                        case 100..<1390:
                            delta2 = (20 - 5*log2(delta/100)).rounded()
                        default:
                            delta2 = 1
                        }
                        print(delta2)
                        if Rating1 < Rating2 {
                            delta2 = 50 - delta2
                        }
                        print(delta2,"Plus/Minus Delta")
                        Rating2-=Int(delta2)
                        Rating1+=Int(delta2)
                        self.myRating = Rating1
                        DispatchQueue.global(qos: .utility).async {
                            let ref2 = Database.database().reference().child("users/\(self.userID!)")
                            ref2.updateChildValues(["rating" : Rating1])
                        }
                        
                    }
                    
                    DispatchQueue.global(qos: .utility).async {
                        let ref3 = Database.database().reference().child("users/\(curID)")
                        ref3.updateChildValues(["health" : curHealth,"rating":Rating2])
                    }
                }
            })
        }
        //можно не алерт будет сделать а всплывающее окно свое
        self.present(alert, animated: true, completion: nil)
        
    }
}

