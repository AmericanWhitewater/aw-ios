import UIKit

class NewsDonateTableViewCell: UITableViewCell {
    @IBOutlet weak var donateButton: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.apply(style: .Headline1)
        subtitle.apply(style: .Text1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func donateTapped(_ sender: Any) {
        UIApplication.shared.open(
                URL(string: "https://www.americanwhitewater.org/content/Membership/donate")!,
                options: [:]) { (status) in
            if status {
                print("Opened browser to donate page")
            }
        }
    }
}
