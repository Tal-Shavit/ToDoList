
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
    
    func displayUserInfo() -> String {
        return "Username: \(username), Email: \(email)"
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }
    
    func moveTask(from sourceIndex: Int, to destinationIndex: Int) {
        let movedTask = tasks.remove(at: sourceIndex)
        tasks.insert(movedTask, at: destinationIndex)
    }
}
