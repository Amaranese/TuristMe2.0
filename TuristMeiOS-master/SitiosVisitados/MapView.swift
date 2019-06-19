
import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var bigMap: MKMapView!
    var sinceDate = Date()
    var untilDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigMap.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        for site in addedSite {
            let anotation = MKPointAnnotation()
            anotation.title = site.title
            anotation.subtitle = site.description
            anotation.coordinate.latitude = site.x_coordinate
            anotation.coordinate.longitude = site.y_coordinate
            
            self.bigMap.addAnnotation(anotation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for place in addedSite {
            let testLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.x_coordinate), longitude: CLLocationDegrees(place.y_coordinate))
            if testLocation.latitude == view.annotation!.coordinate.latitude && testLocation.longitude == view.annotation!.coordinate.longitude {
                let goDetails = self.storyboard?.instantiateViewController(withIdentifier: "siteDetail")
                let detailVc = goDetails as! SiteDetail
                
                detailVc.titleSiteDetail = view.annotation?.title as! String
                detailVc.descriptionDetail = view.annotation?.subtitle as! String
                detailVc.x_coordinate = view.annotation?.coordinate.latitude as! Double
                detailVc.y_coordinate = view.annotation?.coordinate.longitude as! Double
                
                sinceDate = place.since
                let since = dateFormatter.string(from: sinceDate)
                detailVc.sinceSiteDetail = since
                
                untilDate = place.until
                let until = dateFormatter.string(from: untilDate)
                detailVc.untilSiteDetail = until
                
                self.present(goDetails!, animated: true)
            }
        }
    }
}
