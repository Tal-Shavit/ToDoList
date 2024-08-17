import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

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
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.showErrorAlert(message: "Error creating user: \(error.localizedDescription)")
                        return
                    }
                    
                    // שמירת המשתמש עם משימות ריקות ב-Realtime Database
                    if let firebaseUser = authResult?.user {
                        let ref = Database.database().reference()
                        let userDict: [String: Any] = [
                            "username": username,
                            "email": email,
                            "tasks": [] // מערך ריק למשימות בשלב זה
                        ]
                        ref.child("users").child(firebaseUser.uid).setValue(userDict) { error, _ in
                            if let error = error {
                                print("Error saving user: \(error.localizedDescription)")
                            } else {
                                print("User saved successfully!")
                                
                                // מעבר למסך המשימות
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tasksController = storyboard.instantiateViewController(withIdentifier: "TasksID")
                                self.navigationController?.pushViewController(tasksController, animated: true)
                            }
                        }
                    }
                }
        
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                self.showErrorAlert(message: "Error creating user: \(error.localizedDescription)")
//                return
//            }
//            
//            // יצירת אובייקט User ושמירתו ב-Realtime Database
//            if let firebaseUser = authResult?.user {
//                let newUser = User(username: self.userNameTextField.text!, email: self.emailTextField.text!)
//                
//                let ref = Database.database().reference()
//                ref.child("users").child(firebaseUser.uid).setValue(newUser.toDictionary()) { error, _ in
//                    if let error = error {
//                        print("Error saving user: \(error.localizedDescription)")
//                    } else {
//                        print("User saved successfully!")
//                        
//                        // מעבר למסך המשימות
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let tasksController = storyboard.instantiateViewController(withIdentifier: "TasksID")
//                        self.navigationController?.pushViewController(tasksController, animated: true)
//                    }
//                }
//            }
//        }
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
