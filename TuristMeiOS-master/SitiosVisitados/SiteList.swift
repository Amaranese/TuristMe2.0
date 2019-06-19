
import UIKit
import Alamofire

class SiteList: UITableViewController {
    
    @IBOutlet var siteListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        siteListTable.rowHeight = 125
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPlaces()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedSite.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! GestionarCelda
        
        cell.titleLabel.text = addedSite[indexPath.row].title
        cell.sinceLabel.text = addedSite[indexPath.row].since.description
        cell.commentSiteList = addedSite[indexPath.row].description
        cell.untilLabel.text = addedSite[indexPath.row].until.description
        cell.x_coordinate = addedSite[indexPath.row].x_coordinate
        cell.y_coordinate = addedSite[indexPath.row].y_coordinate
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siteDetail = segue.destination as! SiteDetail
        let pressedCell = sender as! GestionarCelda
        siteDetail.titleSiteDetail = pressedCell.titleLabel.text!
        siteDetail.descriptionDetail = pressedCell.commentSiteList
        siteDetail.sinceSiteDetail = pressedCell.sinceLabel.text!
        siteDetail.untilSiteDetail = pressedCell.untilLabel.text!
        siteDetail.x_coordinate = pressedCell.x_coordinate
        siteDetail.y_coordinate = pressedCell.y_coordinate
    }
    
    func getPlaces(){
        let url = "http://localhost:8888/turistme/public/index.php/api/place"
        let _headers : HTTPHeaders = ["Authorization":token]
        
        Alamofire.request(url, method: .get, headers: _headers).responseJSON { response in
            switch response.result{
            case .success:
                switch response.response?.statusCode{
                case 200:
                    let jsonPlaces = response.result.value
                    let places = jsonPlaces as! [String:[[String:Any]]]
                    addedSite.removeAll()
                    for place in places["MESSAGE"]!{
                        let site = Site(title: place["name"] as! String, since: place["start_date"] as! String, until: place["end_date"] as! String, description: place["description"] as! String, x_coordinate: place["x_coordinate"] as! Double, y_coordinate: place["y_coordinate"] as! Double)
                        addedSite.append(site)
                        self.tableView.reloadData()
                    }
                case 403:
                    let alert = UIAlertController(title: "Forbidden", message: "Dont have enough permission", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                default:
                    let alert = UIAlertController(title: "Information", message: "Dont have any place created yet", preferredStyle: .alert)
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
