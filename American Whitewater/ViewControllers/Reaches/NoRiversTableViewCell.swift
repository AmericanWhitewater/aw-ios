import UIKit

class NoRiversTableViewCell: UITableViewCell {

    @IBOutlet weak var noRiversButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        noRiversButton.layer.cornerRadius = noRiversButton.frame.height / 2
        noRiversButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
