import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet var cancelButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInButton.layer.cornerRadius = 22.5
        createAccountButton.layer.cornerRadius = 22.5
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        // close the modal view
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
