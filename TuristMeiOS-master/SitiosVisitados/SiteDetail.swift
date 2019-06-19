
import UIKit
import MapKit
import Alamofire

class SiteDetail: UIViewController, MKMapViewDelegate {
    
    var titleSiteDetail = ""
    var descriptionDetail = ""
    var sinceSiteDetail = ""
    var untilSiteDetail = ""
    var x_coordinate = 0.0
    var y_coordinate = 0.0
    
    @IBOutlet weak var titleSiteDetailLabel: UILabel!
    @IBOutlet weak var descriptionSiteDetail: UILabel!
    @IBOutlet weak var sinceSiteDetailLabel: UILabel!
    @IBOutlet weak var untilSiteDetailLabel: UILabel!
    @IBOutlet weak var mapSiteDetail: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSiteDetail.delegate = self
        titleSiteDetailLabel.text = titleSiteDetail
        descriptionSiteDetail.text = descriptionDetail
        sinceSiteDetailLabel.text = sinceSiteDetail
        untilSiteDetailLabel.text = untilSiteDetail
        
        let anotation = MKPointAnnotation()
        
        anotation.coordinate.latitude = x_coordinate
        anotation.coordinate.longitude = y_coordinate
        
        self.mapSiteDetail.addAnnotation(anotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
