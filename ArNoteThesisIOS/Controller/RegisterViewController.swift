//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordAgainTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        if passwordTextField.text == passwordAgainTextField.text {
            SVProgressHUD.show()
            //TODO: Set up a new user on our Firebase database
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (user, error) in
                
                if error != nil {
                    print(error)
                    let alert = UIAlertController(title: "Sikertelen regisztráció", message: "Szerver hiba", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: nil))
                }
                else
                {
                    print("Registration successful")
                    self.performSegue(withIdentifier: "goToLogin", sender: self)
                }
                SVProgressHUD.dismiss()
            }
        }
        else{
            print("Registration unsuccessful")
            let alert = UIAlertController(title: "Sikertelen regisztráció", message: "A jelszavak nem egyeznek", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: nil))
        }
      
    }
}
