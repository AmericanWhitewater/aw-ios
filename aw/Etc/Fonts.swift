import UIKit

enum Fonts: String {
    case Regular = "OpenSans-Regular"
    case SemiBold = "OpenSans-SemiBold"

    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

struct FontStyle {
    let font: UIFont
    let color: UIColor
}

struct FontStyles {
    static let headline1 = FontStyle(font: Fonts.SemiBold.of(size: 17),
                                     color: UIColor(named: "font_black")!)
    static let text1 = FontStyle(font: Fonts.Regular.of(size: 15),
                                 color: UIColor(named: "font_light_grey")!)
    static let text2 = FontStyle(font: Fonts.Regular.of(size: 13),
                                 color: UIColor(named: "font_very_light_grey")!)
    static let text3 = FontStyle(font: Fonts.Regular.of(size: 17),
                                 color: UIColor(named: "font_black")!)
    static let label1 = FontStyle(font: Fonts.SemiBold.of(size: 15),
                                  color: UIColor(named: "font_black")!)
    static let tab1 = FontStyle(font: Fonts.Regular.of(size: 10),
                                color: UIColor(named: "font_very_light_grey")!)
    static let tab2 = FontStyle(font: Fonts.Regular.of(size: 10),
                                color: UIColor(named: "font_clickable")!)
    static let number1 = FontStyle(font: Fonts.SemiBold.of(size: 17),
                                   color: UIColor(named: "font_black")!)
    static let number2 = FontStyle(font: Fonts.Regular.of(size: 34),
                                   color: UIColor(named: "font_black")!)
}
