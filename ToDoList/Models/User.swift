
import Foundation

class User {
    let username: String
    let email: String
    var tasks: [Task] = []
    
    
    init(username: String, email: String, tasks: [Task] = []) {
        self.username = username
        self.email = email
        self.tasks = tasks
    }
}
