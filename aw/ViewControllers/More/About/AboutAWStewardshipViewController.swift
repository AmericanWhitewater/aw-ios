import UIKit

class AboutAWStewardshipViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
