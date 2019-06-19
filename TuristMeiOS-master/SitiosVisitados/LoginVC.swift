
import Alamofire
import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailLoginField: UITextField!
    @IBOutlet weak var passwordLoginField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func checkLogin() {
        let url = "http://localhost:8888/turistme/public/index.php/api/login/app"
        let parameters: Parameters=[
            "email":emailLoginField.text!,
            "password":passwordLoginField.text!
        ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                if (jsonData["0"]!) as! Int != 200 {
                    let alert = UIAlertController(title: "Error", message: jsonData["MESSAGE"] as! String, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)

                } else {
                    token = jsonData["MESSAGE"] as! String
                    let goMain = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                    self.present(goMain!, animated: true)
                }
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        checkLogin()
    }
}
