import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordAgainTextField: UITextField!
    let firebaseRepository = FireBaseRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordAgainTextField.delegate = self
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        SVProgressHUD.show()
        checkIfTheRegistrationWasSuccessful()
        SVProgressHUD.dismiss()
    }
    
    private func checkIfTheRegistrationWasSuccessful()
    {
        if passwordTextField.text == passwordAgainTextField.text
        {
            firebaseRepository.registerUserIntoFireBaseAuth(email: emailTextField.text!, password: passwordTextField.text!) { (success) -> Void in
                if success { self.performSegue(withIdentifier: "goToLogin", sender: self) }
                else{ self.registrationAlertWindow(title: "Sikertelen regisztráció",message: "Nem megfelelő email cím!",actionTitle: "Oké") }
            }
        }
        else { self.registrationAlertWindow(title: "Sikertelen regisztráció",message: "Nem egyeznek meg a jelszavak!",actionTitle: "Oké") }
    }
    
    private func registrationAlertWindow(title : String, message : String, actionTitle: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordAgainTextField.resignFirstResponder()
        return true
    }
}
