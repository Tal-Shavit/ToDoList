import Foundation
import UIKit

class SingUpController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var signUp: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        guard let username = userNameTextField.text, !username.isEmpty else {
            highlightTextField(userNameTextField)
            return
        }
        resetTextField(userNameTextField)
        
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
        
        guard let confirm = confirmTextField.text, !confirm.isEmpty else {
           highlightTextField(confirmTextField)
            return
        }
       resetTextField(confirmTextField)
        
        guard password == confirm else {
                highlightTextField(passwordTextField)
                highlightTextField(confirmTextField)
                showErrorAlert(message: "Passwords not match")
                return
            }
        
        let newUser = User(username: userNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tasksController = storyboard.instantiateViewController(withIdentifier: "TasksID")
            self.navigationController?.pushViewController(tasksController, animated: true)
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
    }
    
    func resetTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    func highlightTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "confirm", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
