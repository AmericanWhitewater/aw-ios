import Foundation
import UIKit

class CheckBoxButton: UIButton {
    override func awakeFromNib() {
        self.setImage(UIImage(named: "selected"), for: .selected)
        self.setImage(UIImage(named: "deselected"), for: .normal)
        self.addTarget(self, action: #selector(CheckBoxButton.buttonClicked(_:)), for: .touchUpInside)
    }

    @objc func buttonClicked(_ sender: UIButton) {
        self.isSelected = !self.isSelected
    }
}
