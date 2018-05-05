import UIKit

class AboutAWStewardshipViewController: UIViewController {
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyLabel.apply(style: .Text1)
    }

    @IBAction func learnStewardshipTapped(_ sender: Any) {
        UIApplication.shared.open(
            URL(string: "https://www.americanwhitewater.org/content/Stewardship/view/")!,
            options: [:]) { status in
                if status {
                    print("Opened join AW browser")
                }
        }
    }

    @IBAction func knowMoreTapped(_ sender: Any) {
        UIApplication.shared.open(
            URL(string: "https://www.americanwhitewater.org/content/Wiki/aw:about/")!,
            options: [:]) { status in
                if status {
                    print("Opened AW Mission browser")
                }
        }
    }
}
