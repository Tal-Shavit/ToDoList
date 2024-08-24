
import Foundation
import UIKit

class TextFieldUtilities {
    
    static func resetTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    static func highlightTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }
}
