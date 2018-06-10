import UIKit

class TeamMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.font = UIFont(name: "OpenSans", size: 19)
        name.textColor = UIColor(named: "font_blue")
        title.apply(style: .Text1)
        email.apply(style: .Text2)
    }
    
    func setProfilePhoto(image: UIImage) {
        self.profilePhoto.image = image
    }
    
    func setName(name: String) {
        self.name.text = name
    }
    
    func setTitle(title: String) {
        self.title.text = title
    }
    
    func setEmail(email: String) {
        self.email.text = email
    }
}
