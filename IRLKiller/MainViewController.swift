import UIKit
import FirebaseUI
import FirebaseDatabase
import Mapbox
import CoreLocation

class MainViewController: UIViewController, MGLMapViewDelegate {
    
    // Map settings
    let basicLocation = CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742)
    let altitude: CLLocationDistance = 500
    let pitch: CGFloat = 30
    let heading: CLLocationDirection = 180
    
    
//    // Отвечает за геолокации на нашем телефоне //
//    let locationManager = CLLocationManager()
    
//    // Наше вычислимое поле будет каждый раз вычисляться при его запросе //
//    var userLocation: CLLocationCoordinate2D {
//        get { return locationManager.location?.coordinate ?? basicLocation }
//    }
    
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
        let userID = Auth.auth().currentUser?.uid
        //Входим в ДБ сразу в веть с текущим пользователем
        let ref = Database.database().reference().child("users/\(userID!)")
        var login = ""
        
        //чтение логина из БД
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = snapshot.value as? [String : AnyObject] {
                login = user["login"] as! String
                print(login)
                self.loginText.text = login
            }
        })
        
        setupMapView()
//        checkLocationServices()
    }
    
    func setupMapView()  {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
//    func setupLocatinoManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    // Для устройства могут быть выключены службы геолокации, нам нужно это проверить //
//    func checkLocationServices() {
//        if CLLocationManager.locationServicesEnabled() {
//            setupLocatinoManager()
//            checkLocationAuthorization()
//        } else {
//            reportLocationServicesDenied()
//        }
//    }
//
//    // Могут быть отключены службы геолокации для нашего приложения //
//    func checkLocationAuthorization() {
//        switch CLLocationManager.authorizationStatus() {
//        case .denied, .restricted:
//            reportLocationServicesDenied()
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .authorizedWhenInUse:
//            makeAnotationForUserPosition()
//        case .authorizedAlways: break
//        }
//    }
//
//    // Пишем предупреждение о том что выключены службы геолокации или запрещен доступ в наше приложение
//    func reportLocationServicesDenied() {
//        let alert = UIAlertController(title: "Location services disabled", message: "Please go Setting -> Privacy to enable location services for this app.", preferredStyle: .alert)
//
//        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okButton)
//        self.present(alert, animated: true, completion: nil)
//    }
//
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.
        
        let currentCamera = MGLMapCamera(
            lookingAtCenter: userLocation,
            altitude: altitude, pitch: pitch, heading: heading
        )
        mapView.setCamera(currentCamera, animated: true)
    }
    
     func showMyLocation() {
//        removeAnotations()
//        makeAnotationForUserPosition()
        let cameraFocusedOnUsersLocation = MGLMapCamera(
            lookingAtCenter: userLocation,
            altitude: altitude, pitch: pitch, heading: heading
        )
        mapView.fly(to: cameraFocusedOnUsersLocation, withDuration: 2, completionHandler: nil)
    }
}


//// НИХУЯ НЕ РАБОТАЕТ БЛЯТЬ
//extension MainViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        showMyLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationAuthorization()
//        switch CLLocationManager.authorizationStatus() {
//        case .denied:
//            removeAnotations()
//        case .authorizedAlways, .authorizedWhenInUse:
//            showMyLocation()
//        default:
//            break
//        }
//    }
//}
