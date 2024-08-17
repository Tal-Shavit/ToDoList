
import Foundation
import UIKit
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            highlightTextField(emailTextField)
            return
        }
        resetTextField(emailTextField)
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            highlightTextField(passwordTextField)
            return
        }
        resetTextField(passwordTextField)
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // טיפול בשגיאה והצגת הודעה למשתמש
                return
            }
            
            // אם ההתחברות הצליחה, מעבר למסך המשימות
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tasksController = storyboard.instantiateViewController(withIdentifier: "TasksID")
            self.navigationController?.pushViewController(tasksController, animated: true)
        }
    }
    
    
    func resetTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    func highlightTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }
    
}
