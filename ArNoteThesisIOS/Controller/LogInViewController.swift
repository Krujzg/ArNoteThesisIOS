import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning() }

    @IBAction func logInPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        //loginWithFireBaseAuth()
        //firebaseRepository.retrieveNotes(completionHandler:{ (success, myNote) -> Void in if success { self.setTableViewData(myNote: myNote)}  })
        FireBaseRepository.shared.loginWithFireBaseAuth(email: emailTextField.text!, password: passwordTextField.text!) { (success) -> Void in
            if success
            {
                self.performSegue(withIdentifier: "goToMainMenu", sender: self)
                
            }
            else{
                let alert = UIAlertController(title: "Helytelen bejelentkezés", message: "Hibás felhasználónév vagy jelszó", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: nil))
            }
            SVProgressHUD.dismiss()
        }
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}  
