import UIKit
import FirebaseUI
import FirebaseDatabase
import Mapbox

class MainViewController: UIViewController,MGLMapViewDelegate {
    
    // Чисто для теста,в игре нельзя разлогиниться
    @IBAction func logoutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil) //загрузка экрана логина
    }
    
    @IBOutlet weak var testText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser?.uid
        //Входим в ДБ сразу в веть с текущим пользователем
        let ref = Database.database().reference().child("users/\(userID!)")
        var login = ""
        
        //
        //чтение логина из БД
        ref.observeSingleEvent(of: .value,with: {(snapshot) in
            if let user = snapshot.value as? [String : AnyObject] {
                login = user["login"] as! String
                print(login)
                self.testText.text = login
            }
        })
        
        setUpMapView()
        
    }
    
    func setUpMapView(){
        // доабавляю программно
        let mapView = MGLMapView(frame: view.bounds, styleURL: URL(string:"mapbox://styles/b1boid/ck12egt7e02ax1cp52uginkky"))
        
        // Чтобы не видно было надписи mapbox внизу - смещаю
        mapView.frame = CGRect(x: 0, y: 60, width: view.bounds.maxX, height: view.bounds.maxY)
        
        
        //mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 10, animated: false)
        
        view.addSubview(mapView)
        
        // Set the map view's delegate
        mapView.delegate = self
        
        // Allow the map view to display the user's location
        mapView.showsUserLocation = true
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.
        
        // Create a camera that rotates around the same center point, rotating 180°.
        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
        let camera = MGLMapCamera(lookingAtCenter: mapView.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), altitude: 500, pitch: 30, heading: 180)
        
        // Animate the camera movement over 2 seconds.
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    }
    

    
}
