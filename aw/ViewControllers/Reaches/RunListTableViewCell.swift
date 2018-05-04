import CoreData
import UIKit

class RunListTableViewCell: UITableViewCell, MOCViewControllerType {

    var managedObjectContext: NSManagedObjectContext?

    var reach: Reach?

    private let conditionColorView: UIView = {
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()

    private let riverName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let sectionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = UIColor(named: "font_grey")
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let difficultyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private let distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .right
        lbl.textColor = UIColor(named: "font_grey")
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(conditionColorView)

        NSLayoutConstraint.activate([
            conditionColorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            conditionColorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            conditionColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            conditionColorView.widthAnchor.constraint(equalToConstant: 8)
            ])

        let rightStack = UIStackView(arrangedSubviews: [distanceLabel, favoriteButton])
        rightStack.axis = .vertical
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        rightStack.distribution = .equalSpacing
        rightStack.alignment = .trailing

        let leftSubStack = UIStackView(arrangedSubviews: [riverName, sectionLabel])
        leftSubStack.axis = .vertical
        leftSubStack.spacing = 2
        leftSubStack.translatesAutoresizingMaskIntoConstraints = false
        leftSubStack.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)

        let leftStack = UIStackView(arrangedSubviews: [leftSubStack, difficultyLabel])
        leftStack.axis = .vertical
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        leftStack.distribution = .fill
        leftStack.alignment = .fill
        leftStack.spacing = 8
        leftStack.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)

        let horizontalStack = UIStackView(arrangedSubviews: [leftStack, rightStack])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        horizontalStack.distribution = .fill
        horizontalStack.alignment = .fill
        contentView.addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            horizontalStack.leftAnchor.constraint(equalTo: conditionColorView.rightAnchor, constant: 16),
            horizontalStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(reach: Reach) {
        self.reach = reach

        draw()
    }

    func draw() {
        if let reach = reach {
            conditionColorView.backgroundColor = reach.color

            riverName.text = reach.name
            sectionLabel.text = reach.sectionCleanedHTML
            difficultyLabel.text = "Level: \(reach.readingFormatted) Class: \(reach.difficulty ?? "Unknown")"
            difficultyLabel.textColor = reach.color
            distanceLabel.text = reach.lengthFormatted

            let favoriteIcon = reach.favorite ?
                UIImage(named: "icon_favorite_selected") : UIImage(named: "icon_favorite")
            favoriteButton.setImage(favoriteIcon, for: .normal)

        }
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        managedObjectContext?.persist {
            guard let reach = self.reach else { return }
            reach.favorite = !reach.favorite
        }
    }
}
