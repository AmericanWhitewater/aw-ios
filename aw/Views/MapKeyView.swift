import UIKit

class MapKeyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(pointTypes: [(UIImage?, String)]) {
        self.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 45 / 2
        layer.masksToBounds = true
        backgroundColor = UIColor.white

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        for (image, name) in pointTypes {
            let pointStack = UIStackView()
            pointStack.translatesAutoresizingMaskIntoConstraints = false
            pointStack.axis = .horizontal
            pointStack.distribution = .fill
            pointStack.alignment = .fill
            pointStack.spacing = 4

            if let image = image {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                pointStack.addArrangedSubview(imageView)
            }
            let lbl = UILabel()
            lbl.text = name
            lbl.font = UIFont.systemFont(ofSize: 12)
            pointStack.addArrangedSubview(lbl)

            stackView.addArrangedSubview(pointStack)
        }

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 23),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
