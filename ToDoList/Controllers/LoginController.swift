
import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        openNewControlletr(withIdentifier: "SignUpController")
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
            
            if let firebaseUser = authResult?.user {
                let ref = Database.database().reference()
                ref.child("users").child(firebaseUser.uid).observeSingleEvent(of: .value) { snapshot in
                    if let data = snapshot.value as? [String: Any] {
                        let username = data["username"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let tasksArray = data["tasks"] as? [[String: Any]] ?? []
                
                        let tasks = tasksArray.map { dict -> Task in
                            let name = dict["name"] as? String ?? ""
                            let isChecked = dict["isChecked"] as? Bool ?? false
                            return Task(name: name, isChecked: isChecked)
                        }
                                            
                        self.user = User(username: username, email: email, tasks: tasks)
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
    
    func resetTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    func highlightTextField(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }
    
}
