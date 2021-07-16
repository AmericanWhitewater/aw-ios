import UIKit

enum Fonts: String {
    case Regular = "OpenSans-Regular"
    case SemiBold = "OpenSans-SemiBold"

    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

enum FontStyle {
    /// Black semi-bold 17
    case Headline1
    /// Grey regular 17
    case Text1
    /// Light grey regular 13
    case Text2
    /// Black regular 17
    case Text3
    /// Black semi-bold 15
    case Text4
    /// Grey regular 13
    case Label1
    /// Light grey regular 10
    case Tab1
    /// Clickable regular 10
    case Tab2
    /// Black semi-bold 17
    case Number1
    /// Black regular 34
    case Number2

    func font() -> UIFont {
        switch self {
        case .Headline1:
            return Fonts.SemiBold.of(size: 17)
        case .Text1:
            return Fonts.Regular.of(size: 15)
        case .Text2:
            return Fonts.Regular.of(size: 13)
        case .Text3:
            return Fonts.Regular.of(size: 17)
        case .Text4:
            return Fonts.Regular.of(size: 13)
        case .Label1:
            return Fonts.SemiBold.of(size: 15)
        case .Tab1, .Tab2:
            return Fonts.Regular.of(size: 10)
        case .Number1:
            return Fonts.SemiBold.of(size: 17)
        case .Number2:
            return Fonts.Regular.of(size: 34)
        }
    }

    func color() -> UIColor {
        switch self {
        case .Headline1:
            return UIColor(named: "font_black")!
        case .Text1:
            return UIColor(named: "font_grey")!
        case .Text2:
            return UIColor(named: "font_light_grey")!
        case .Text3:
            return UIColor(named: "font_black")!
        case .Text4:
            return UIColor(named: "font_grey")!
        case .Label1:
            return UIColor(named: "font_black")!
        case .Tab1:
            return UIColor(named: "font_light_grey")!
        case .Tab2:
            return  UIColor(named: "font_clickable")!
        case .Number1, .Number2:
            return UIColor(named: "font_black")!
        }
    }
}
