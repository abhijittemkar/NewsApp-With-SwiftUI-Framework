//  String+Extension.swift

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
