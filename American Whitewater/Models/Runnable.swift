import Foundation

struct Runnable {
    static func fromRc(rcString: String) -> String {
        switch rcString {
        case "H0", "H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9":
            return "Above Recommended"
        case "L0", "L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8", "L9":
            return "Below Recommended"
        case "R0", "R1", "R2":
            return "Lower Runnable"
        case "R3", "R4", "R5", "R6":
            return "Runnable"
        case "R7", "R8", "R9":
            return "Upper Runnable"
        default:
            return ""
        }
    }
}
