import UIKit

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
        FireBaseRepository.shared.logoutTheUser()
        guard navigationController?.popToRootViewController(animated: true) != nil
        else
        {
            print("no View Controllers to pop off")
            return
        }
    }
}
