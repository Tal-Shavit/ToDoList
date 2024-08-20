
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var statesCardView: UIView!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var notDoneLabel: UILabel!
    
    var user: User?
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCardView()
        updateTableViewHeight()
        updateTotalLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkmarkChanged), name: NSNotification.Name("checkmarkChanged"), object: nil)
        
        loadTasksFromFirebase()
    }
    
    @IBAction func onSettings(_ sender: Any) {
        if cardTableView.isEditing{
            cardTableView.isEditing = false
        }
        else{
            cardTableView.isEditing = true
        }
    }
    
    func initCardView(){
        statesCardView.layer.cornerRadius = 10
        statesCardView.layer.shadowColor = UIColor.black.cgColor
        statesCardView.layer.shadowOpacity = 0.2
        statesCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        statesCardView.layer.shadowRadius = 4
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "ADD TASK", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Task Name"
        }
        
        let addAction = UIAlertAction(title: "confirm", style: .default) { _ in
            if let taskName = alertController.textFields?.first?.text, !taskName.isEmpty {
                self.addTask(Task(name: taskName))
            }
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loadTasksFromFirebase() {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("users").child(firebaseUser.uid).child("tasks")
        
        ref.observe(.value) { snapshot in
            self.tasks.removeAll()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let taskData = childSnapshot.value as? [String: Any],
                   let taskName = taskData["name"] as? String,
                   let isChecked = taskData["isChecked"] as? Bool {
                
                    let task = Task(name: taskName, isChecked: isChecked)
                    self.tasks.append(task)
                }
            }
            
            self.cardTableView.reloadData()
            self.updateTableViewHeight()
            self.updateTotalLabel()
            self.updateDoneLabel()
        }
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        cardTableView.reloadData()
        updateTableViewHeight()
        updateTotalLabel()
        updateDoneLabel()
        saveTaskToFirebase(task)
    }
    
    func saveTaskToFirebase(_ task: Task) {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("users").child(firebaseUser.uid).child("tasks")
        
        let taskDict: [String: Any] = [
            "name": task.name,
            "isChecked": task.isChecked
        ]
        
        let newTaskRef = ref.childByAutoId()
        newTaskRef.setValue(taskDict)
    }
    
    func updateTableViewHeight() {
        let contentHeight = cardTableView.contentSize.height
        tableViewHeightConstraint.constant = contentHeight
        view.layoutIfNeeded()
    }
    
    func updateTotalLabel() {
        totalLabel.text = "\(tasks.count)"
    }
    
    @objc func checkmarkChanged() {
        updateDoneLabel()
    }
    
    func updateDoneLabel() {
        var doneCount = 0
        var notDoneCount = 0
        for i in 0..<tasks.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = cardTableView.cellForRow(at: indexPath) as? CardCell, cell.isCheckmarkVisible {
                getTaskByName(taskName: tasks[i].name) { snapshot in
                    if let taskSnapshot = snapshot {
                        let newValues = ["isChecked": true] // ערכים חדשים לעדכון
                        self.updateTask(taskSnapshot: taskSnapshot, newValues: newValues) { error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            } else {
                                print("Task updated successfully")
                            }
                        }
                    } else {
                        print("Task not found")
                    }
                }
                doneCount += 1
            }
            if let cell = cardTableView.cellForRow(at: indexPath) as? CardCell, !cell.isCheckmarkVisible {
                getTaskByName(taskName: tasks[i].name) { snapshot in
                    if let taskSnapshot = snapshot {
                        let newValues = ["isChecked": false]
                        self.updateTask(taskSnapshot: taskSnapshot, newValues: newValues) { error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            } else {
                                print("Task updated successfully")
                            }
                        }
                    } else {
                        print("Task not found")
                    }
                }
                notDoneCount += 1
            }
        }
        doneLabel.text = "\(doneCount)"
        notDoneLabel.text = "\(notDoneCount)"
    }
    
    func getTaskByName(taskName: String, completion: @escaping (DataSnapshot?) -> Void) {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("users").child(firebaseUser.uid).child("tasks")
        
        ref.queryOrdered(byChild: "name").queryEqual(toValue: taskName).observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    completion(childSnapshot)
                    return
                }
            }
            completion(nil)
        }
    }
    
    func updateTask(taskSnapshot: DataSnapshot, newValues: [String: Any], completion: @escaping (Error?) -> Void) {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        let ref = taskSnapshot.ref
        
        ref.updateChildValues(newValues) { error, _ in
            completion(error)
        }
    }
    
}


extension ViewController:  UITabBarDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return cardTableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
                let task = tasks[indexPath.row]
                cell.isCheckmarkVisible = task.isChecked
                if cell.isCheckmarkVisible {
                    cell.checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                } else {
                    cell.checkButton.setImage(UIImage(), for: .normal)
                }
                
                cell.titleLabel.text = task.name
                return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateTotalLabel()
            self.updateDoneLabel()
            self.updateTableViewHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tasks.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.updateTotalLabel()
        self.updateDoneLabel()
        self.updateTableViewHeight()
    }
}
