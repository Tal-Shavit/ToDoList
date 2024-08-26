import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var signUp: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func onLogin(_ sender: Any) {
        openNewControlletr(withIdentifier: "LoginController")
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        guard let username = userNameTextField.text, !username.isEmpty else {
            TextFieldUtilities.highlightTextField(userNameTextField)
            return
        }
        TextFieldUtilities.resetTextField(userNameTextField)
        
        guard let email = emailTextField.text, !email.isEmpty else {
            TextFieldUtilities.highlightTextField(emailTextField)
            return
        }
        TextFieldUtilities.resetTextField(emailTextField)
        
        guard let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
            TextFieldUtilities.highlightTextField(passwordTextField)
            return
        }
        TextFieldUtilities.resetTextField(passwordTextField)
        
        guard let confirm = confirmTextField.text, !confirm.isEmpty else {
            TextFieldUtilities.highlightTextField(confirmTextField)
            return
        }
        TextFieldUtilities.resetTextField(confirmTextField)
        
        guard password == confirm else {
            TextFieldUtilities.highlightTextField(passwordTextField)
            TextFieldUtilities.highlightTextField(confirmTextField)
            showErrorAlert(message: "Passwords not match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let firebaseUser = authResult?.user {
                let ref = Database.database().reference()
                let userDict: [String: Any] = [
                    "username": username,
                    "email": email,
                    "tasks": []
                ]
                ref.child("users").child(firebaseUser.uid).setValue(userDict) { error, _ in
                    if let error = error {
                        print("Error")
                    } else {
                        self.openNewControlletr(withIdentifier: "TasksID")
                    }
                }
            }
        }
    }
    
    func openNewControlletr(withIdentifier identifier: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "confirm", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
