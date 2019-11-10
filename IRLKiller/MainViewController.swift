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
    }
    
    class MyCustomPointAnnotation: MGLPointAnnotation {
        var typeOfImage: String = "online"
    }
    
    
    var players = [String : Player]()
    
    var annotationsPlayers = [String : MGLAnnotation]()
    
    var myLogin = ""
    
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
        
        let curPlayer = Player(
            login: curLogin,
            position: CLLocationCoordinate2D(latitude: posx, longitude: posy),
            isOnline: isOnline
        )
        
        self.players[curLogin] = curPlayer
        
        print("show: \(curLogin)")
        print("x: \(posx), y: \(posy)")
        
        // тут отрисовываем чела на карте
        if curLogin != myLogin {
            let curPoint: MyCustomPointAnnotation = {
                let anotation = MyCustomPointAnnotation()
                anotation.coordinate = CLLocationCoordinate2D(latitude: posx, longitude: posy)
                anotation.title = curLogin
                anotation.typeOfImage = isOnline ? "online" : "offline"
                return anotation
            }()
            
            if !isAdding {
                mapView.removeAnnotation(annotationsPlayers[curLogin]!)
            }
            mapView.addAnnotation(curPoint)
            self.annotationsPlayers[curLogin] = curPoint
        }
    }
    
    @objc func updateDB() {
        let ref = Database.database().reference().child("users/\(userID!)")
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
}

