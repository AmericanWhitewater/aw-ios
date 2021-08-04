import UIKit
import OAuthSwift
import KeychainSwift

class SignInViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet var cancelButton: UIView!
        
    var oauthswift: OAuthSwift?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInButton.layer.cornerRadius = 22.5
        createAccountButton.layer.cornerRadius = 22.5
        
        DefaultsManager.shared.signInLastShown = Date()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        // close the modal view
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        attemptAWOAuth()
    }
    
    
    // AWTODO: should this open the page in a safari controller?
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        if let url = URL(string: "https://www.americanwhitewater.org/content/User/login") {
            UIApplication.shared.open(url)
        } else {
            let alert = UIAlertController(
                title: "Unable to Create Account",
                message: "Please visit: https://americanwhitewater.org to create an account.",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }

    func attemptAWOAuth() {
        let oauth = OAuth2Swift(
            consumerKey: AWGC.AWConsumerKey,
            consumerSecret: AWGC.AWConsumerSecret,
            authorizeUrl: "\(AWGC.AW_BASE_URL)/oauth/authorize",
            accessTokenUrl: "\(AWGC.AW_BASE_URL)/oauth/token",
            responseType: "token"
        )
    
        self.oauthswift = oauth
        oauth.encodeCallbackURL = true
        oauth.encodeCallbackURLQuery = false
        //oauth.authorizeURLHandler = OAuthSwiftOpenURLExternally.sharedInstance
        oauth.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
        
        let _ = oauth.authorize(
            withCallbackURL: URL(string: AWGC.AWCallbackUrl)!,
            scope: "",
            state: "") { result in
                switch result {
                case .success(let (credential, _, _)):
                    
                    //print(credential.oauthToken)
                    
                    // Save token to local app keychain for security
                    let keychain = KeychainSwift();
                    keychain.set(credential.oauthToken, forKey: AWGC.AuthKeychainToken)
                    //keychain.delete("ios-aw-auth-key") // for sign out
                    //print("Keychain auth key is: ", keychain.get("ios-aw-auth-key"))
                    
                    DefaultsManager.shared.signedInAuth = "true"
                    
                    // Dismiss login box
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    print("ERROR!!!!!!--> ", error.description)
                }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
