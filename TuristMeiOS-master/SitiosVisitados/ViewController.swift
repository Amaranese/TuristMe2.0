
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func register(){
        let url = "http://localhost:8888/turistme/public/index.php/api/user"
        let parameters: Parameters = [
            "name":nameField.text!,
            "email":emailField.text!,
            "password":passwordField.text!
        ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                if (jsonData["0"]!) as! Int != 200 {
                    let alert = UIAlertController(title: "Error", message: jsonData["MESSAGE"] as! String, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    let goLogin = self.storyboard?.instantiateViewController(withIdentifier: "login")
                    self.present(goLogin!, animated: true)
                }
            }
        }
    }
    
    @IBAction func userRegister(_ sender: UIButton) {
        if confirmPasswordField.text == passwordField.text {
            register()
        }else{
            let alert = UIAlertController(title: "Error", message: "The confirm password is not correct" as! String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
}

