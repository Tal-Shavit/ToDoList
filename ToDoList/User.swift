
import Foundation

class User {
    let username: String
    let email: String
    let password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    func displayUserInfo() -> String {
        return "Username: \(username), Email: \(email)"
    }
}
