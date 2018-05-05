import UIKit

class AboutAWFundingViewController: UIViewController {
    @IBOutlet weak var bodyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bodyLabel.apply(style: .Text1)
    }

    @IBAction func donateNowTapped(_ sender: Any) {
        UIApplication.shared.open(
            URL(string: "https://www.americanwhitewater.org/content/Membership/donate")!,
            options: [:]) { status in
                if status {
                    print("Opened join AW browser")
                }
        }
    }

    @IBAction func joinMembershipTapped(_ sender: Any) {
        UIApplication.shared.open(
            URL(string: "https://www.americanwhitewater.org/content/Membership/join-aw")!,
            options: [:]) { status in
                if status {
                    print("Opened AW Mission browser")
                }
        }
    }
}
