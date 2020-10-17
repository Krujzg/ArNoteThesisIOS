
import UIKit
import Firebase
import SVProgressHUD


class LogInViewController: UIViewController, UITextFieldDelegate {
    
   
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logInPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
        {
            (user, error) in
            if error != nil
            {
                print(error!)
            }
            else{
                print("login successful")
               
                
                self.performSegue(withIdentifier: "goToMainMenu", sender: self)
            }
            
            SVProgressHUD.dismiss()
            
            
        }
    }
}  
