//
//  MenuViewController.swift
//  ArNoteThesisIOS
//
//  Created by Gergo on 2020. 10. 11..
//

import UIKit
import FirebaseAuth

class MenuViewController : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func LogoutTheUser(_ sender: UIButton)
    {
        do
        {
         try Auth.auth().signOut()
        }
        catch {print(error)}
        
        guard navigationController?.popToRootViewController(animated: true) != nil
        else
        {
            print("no View Controllers to pop off")
            return
        }
    }
}
