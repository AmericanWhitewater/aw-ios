import UIKit

class NewsDonateTableViewCell: UITableViewCell {
    @IBOutlet weak var donateButton: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.apply(style: .Headline1)
        subtitle.apply(style: .Text1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewsDonateTableViewCell.subtitleTapped))
        subtitle.isUserInteractionEnabled = true
        subtitle.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc
    func subtitleTapped(sender: UITapGestureRecognizer) {
        if (subtitle.numberOfLines == 0) {
            print("resizing to 4")
            subtitle.numberOfLines = 4
        } else {
            print("resizing to 0")
            subtitle.numberOfLines = 0
        }
        
        self.sizeToFit()
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
