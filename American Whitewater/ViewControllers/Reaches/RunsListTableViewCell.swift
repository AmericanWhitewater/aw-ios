import UIKit

class RunsListTableViewCell: UITableViewCell {

    @IBOutlet weak var runTitleLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var runLevelAndClassLabel: UILabel!
    @IBOutlet weak var runStatusLeftBar: UIView!
    @IBOutlet weak var runFavoritesButton: UIButton!
    @IBOutlet weak var runDistanceAwayLabel: UILabel!
    @IBOutlet weak var runAlertsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        runDistanceAwayLabel?.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
