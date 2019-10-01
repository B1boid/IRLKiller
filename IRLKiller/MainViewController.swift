import UIKit
import FirebaseUI
import FirebaseDatabase
import Mapbox

class MainViewController: UIViewController, MGLMapViewDelegate {
    
    
    // Map settings
    let basicLocation = CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742)
    let altitude: CLLocationDistance = 500
    let pitch: CGFloat = 30
    let heading: CLLocationDirection = 180
    
    
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
    
        setUpMapView()
        
    }
    
    
    func setUpMapView() {
        
        // Set the map view's delegate
        mapView.delegate = self
        
        // Allow the map view to display the user's location
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.

        // Create a camera that rotates around the same center point, rotating 180°.
        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
        
        //Вообщем есть необьяснимый баг - при запуске программы когда эмулятор закрыт, то есть когда эмулятор открывается и сразу запускается приложение - иногда не находит координаты пользователя сразу, поэтому вводим вспомогательную камеру на фиксированную точку(в будущем на последнее местопложение пользователя)
        let previousCamera = MGLMapCamera(
            lookingAtCenter: basicLocation, altitude: altitude, pitch: pitch, heading: heading
        )
        mapView.fly(to: previousCamera, withDuration: 2, completionHandler: nil)
        
        let currentCamera = MGLMapCamera(
            lookingAtCenter: mapView.userLocation?.coordinate ?? basicLocation,
            altitude: altitude, pitch: pitch, heading: heading
        )
        mapView.setCamera(currentCamera, animated: true)
    }
    
    func showMyLocation(){
        let cameraFocusedOnUsersLocation = MGLMapCamera(
            lookingAtCenter: mapView.userLocation?.coordinate ?? mapView.centerCoordinate,
            altitude: altitude, pitch: pitch, heading: heading
        )
        mapView.fly(to: cameraFocusedOnUsersLocation, withDuration: 2, completionHandler: nil)
    }
}
