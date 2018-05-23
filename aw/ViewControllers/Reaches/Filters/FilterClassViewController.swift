import UIKit

class FilterClassViewController: UIViewController {
    @IBOutlet weak var class1: CheckBoxButton!
    @IBOutlet weak var class2: CheckBoxButton!
    @IBOutlet weak var class3: CheckBoxButton!
    @IBOutlet weak var class4: CheckBoxButton!
    @IBOutlet weak var class5: CheckBoxButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

}

extension FilterClassViewController {
    func initialize() {
        setCheckboxes()
    }

    func setCheckboxes() {
        let difficultyRange = DefaultsManager.classFilter

        class1.isSelected = difficultyRange.contains(1)
        class2.isSelected = difficultyRange.contains(2)
        class3.isSelected = difficultyRange.contains(3)
        class4.isSelected = difficultyRange.contains(4)
        class5.isSelected = difficultyRange.contains(5)
    }
}

extension FilterClassViewController: FilterViewControllerType {
    func save() {
        var range: [Int] = []

        if class1.isSelected { range.append(1) }
        if class2.isSelected { range.append(2) }
        if class3.isSelected { range.append(3) }
        if class4.isSelected { range.append(4) }
        if class5.isSelected { range.append(5) }

        DefaultsManager.classFilter = range
    }
}
