import UIKit

class TeamMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
