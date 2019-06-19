
import UIKit
import MapKit
import Alamofire

class AddSite: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var sinceDatePicker: UIDatePicker!
    @IBOutlet weak var untilDatePicker: UIDatePicker!
    @IBOutlet weak var map: MKMapView!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    

    override func viewDidLoad() {
        map.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func navigation(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateFormatter.string(from: untilDatePicker.date)
        dateFormatter.string(from: sinceDatePicker.date)
        
        addSiteRequest()
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.map)
        coordinate = map.convert(location, toCoordinateFrom: map)
        let anotation = MKPointAnnotation()
        //var view: MKPinAnnotationView
        
        anotation.coordinate = coordinate
        anotation.title = titleField.text!
        anotation.subtitle = commentField.text!
        
        self.map.removeAnnotations(map.annotations)
        self.map.addAnnotation(anotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.image = #imageLiteral(resourceName: "maps-and-location")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func addSiteRequest() {
        let url = "http://localhost:8888/turistme/public/index.php/api/place"
        let parameters: Parameters=[
            "name":titleField.text!,
            "description":commentField.text!,
            "start_date":sinceDatePicker.date,
            "end_date":untilDatePicker.date,
            "x_coordinate":coordinate.latitude,
            "y_coordinate":coordinate.longitude
        ]
        let _headers : HTTPHeaders = ["Authorization":token]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseString { response in
            switch response.result{
            case .success:
                switch response.response?.statusCode{
                case 200:
                    let completeSite = Site(title: self.titleField.text!, since: self.sinceDatePicker.date, until: self.untilDatePicker.date, description: self.commentField.text!, x_coordinate: self.coordinate.latitude, y_coordinate: self.coordinate.longitude)
                     addedSite.append(completeSite)
                     self.tabBarController?.selectedIndex = 0
                case 403:
                    let alert = UIAlertController(title: "Forbidden", message: "Dont have enough permission", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                default:
                    let alert = UIAlertController(title: "Error", message: "The information is not correct", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                break
            case .failure( _):
                let alert = UIAlertController(title: "Error", message: "Critical Error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
