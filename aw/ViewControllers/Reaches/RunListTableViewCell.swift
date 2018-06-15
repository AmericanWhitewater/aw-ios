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
        lbl.apply(style: .Headline1)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let sectionLabel: UILabel = {
        let lbl = UILabel()
        lbl.apply(style: .Text1)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let difficultyLabel: UILabel = {
        let lbl = UILabel()
        lbl.apply(style: .Label1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(conditionColorView)

        NSLayoutConstraint.activate([
            conditionColorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            conditionColorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            conditionColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            conditionColorView.widthAnchor.constraint(equalToConstant: 8)
            ])

        let rightStack = UIStackView(arrangedSubviews: [favoriteButton])
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
        let conditionColor = conditionColorView.backgroundColor
        super.setSelected(selected, animated: animated)
        conditionColorView.backgroundColor = conditionColor
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let conditionColor = conditionColorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        conditionColorView.backgroundColor = conditionColor
    }

    func setup(reach: Reach) {
        self.reach = reach

        draw()
    }

    func draw() {
        if let reach = reach {
            conditionColorView.backgroundColor = reach.color

            riverName.text = reach.name
            sectionLabel.text = reach.sectionName
            difficultyLabel.text = reach.runnableClass
            difficultyLabel.textColor = reach.color

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
