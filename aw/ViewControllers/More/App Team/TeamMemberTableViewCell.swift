import UIKit

class TeamMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var email: UILabel!
    
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
