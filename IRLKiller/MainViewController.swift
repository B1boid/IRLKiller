import UIKit
import FirebaseUI
import FirebaseDatabase
import Mapbox
import CoreLocation

class MainViewController: UIViewController, MGLMapViewDelegate {
    
    // Map settings
    var basicLocation = CLLocationCoordinate2D (latitude: 48.8582573, longitude: 2.2945111)
    //(latitude: 40.74699, longitude: -73.98742)
    let altitude: CLLocationDistance = 500
    let pitch: CGFloat = 30
    let heading: CLLocationDirection = 180
    let userID = Auth.auth().currentUser?.uid
    
    struct Player {
        
        var login:String
        var position:CLLocationCoordinate2D
        var isOnline:Bool
        
        init(login:String, position:CLLocationCoordinate2D, isOnline:Bool) {
            self.login = login;
            self.position = position;
            self.isOnline = isOnline;
        }
    }
    
    var players = [String : Player]()
    
    
    var userLocation: CLLocationCoordinate2D {
        get { return mapView.userLocation?.coordinate ?? basicLocation }
    }
    
    
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
        self.dismiss(animated: false, completion: nil) //загрузка экрана логина
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Входим в ДБ сразу в веть с текущим пользователем
        let ref = Database.database().reference().child("users/\(userID!)")
        var login = ""
        
        //чтение логина из БД
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = snapshot.value as? [String : AnyObject] {
                login = user["login"] as! String
                print(login)
                self.loginText.text = login
                let offlinePosX = user["pos-x"] as! Double
                let offlinePosY = user["pos-y"] as! Double
                
                //Камеру на последнюю локацию на всякий случай
                self.basicLocation = CLLocationCoordinate2D(latitude: offlinePosX, longitude: offlinePosY)

                let currentCamera0 = MGLMapCamera(
                    lookingAtCenter: self.basicLocation,
                    altitude: self.altitude, pitch: self.pitch, heading: self.heading
                )
                self.mapView.setCamera(currentCamera0, animated: false)
                
                // Камера на текущую позицию, если нашлась
                let currentCamera = MGLMapCamera(
                    lookingAtCenter: self.userLocation,
                    altitude: self.altitude, pitch: self.pitch, heading: self.heading
                )
                self.mapView.setCamera(currentCamera, animated: false)
                
            }
        })
        
        setupMapView()
        
        //Каждые 5 секунд записывает твое новое местоположение в БД, если совпадает со старым обновление записи не происходит
        let _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateDB), userInfo: nil, repeats: false)
       
        let ref2 = Database.database().reference().child("users")
        
        // Вызывается автоматически, когда изменяется какое либо значение у чела и отрисовывает его местопложение
        ref2.observe(.childChanged) { (snapshot) in
            self.readNewData(snapshot: snapshot)
        }
        
        //вызывается в самом начале и отрисовывает всех челов, а также когда новый чел зарегистрировался тоже вызовется автоматичеки и его отрисует
        ref2.observe(.childAdded) { (snapshot) in
            self.readNewData(snapshot: snapshot)
        }
    }
    
    func readNewData(snapshot:DataSnapshot){
        
        let isOnline = snapshot.childSnapshot(forPath: "online").value as! Bool
        let curLogin = snapshot.childSnapshot(forPath: "login").value as! String
        let posx = snapshot.childSnapshot(forPath: "pos-x").value as! Double
        let posy = snapshot.childSnapshot(forPath: "pos-y").value as! Double
        
        let curPlayer = Player(login: curLogin,position: CLLocationCoordinate2D(latitude: posx, longitude: posy),isOnline: isOnline)
        
        self.players[curLogin] = curPlayer
        
        print("show: \(curLogin)")
        print("pos: \(posx)")
        
        // тут отрисовываем чела на карте
    }
    
    @objc func updateDB(){
        print("Data Load to DB")
        
        let ref = Database.database().reference().child("users/\(userID!)")
        ref.updateChildValues(["online" : true ,"pos-x": userLocation.latitude,"pos-y": userLocation.longitude])
        
        let _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateDB), userInfo: nil, repeats: false)
        
//        for (curLog,player) in players {
//            print(player.login)
//            print(player.position.latitude)
//        }
    }
    
    
    func setupMapView()  {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.
        
//        let currentCamera = MGLMapCamera(
//            lookingAtCenter: userLocation,
//            altitude: altitude, pitch: pitch, heading: heading
//        )
       // mapView.setCamera(currentCamera, animated: false)
        
        
    }
    
     func showMyLocation() {
        let cameraFocusedOnUsersLocation = MGLMapCamera(
            lookingAtCenter: userLocation,
            altitude: altitude, pitch: pitch, heading: heading
        )
        mapView.fly(to: cameraFocusedOnUsersLocation, withDuration: 2, completionHandler: nil)
    }
}
