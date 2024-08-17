
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var statesCardView: UIView!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var notDoneLabel: UILabel!
    var tasks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCardView()
        updateTableViewHeight()
        updateTotalLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkmarkChanged), name: NSNotification.Name("checkmarkChanged"), object: nil)
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
                self.addTask(taskName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addTask(_ taskName: String) {
        tasks.append(taskName)
        cardTableView.reloadData()
        updateTableViewHeight()
        updateTotalLabel()
        updateDoneLabel()
    }
    
    func updateTableViewHeight() {
        let contentHeight = cardTableView.contentSize.height
        tableViewHeightConstraint.constant = contentHeight
        view.layoutIfNeeded() // מרענן את הפריסה עם הגובה החדש
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
                doneCount += 1
            }
            if let cell = cardTableView.cellForRow(at: indexPath) as? CardCell, !cell.isCheckmarkVisible {
                notDoneCount += 1
            }
        }
        doneLabel.text = "\(doneCount)"
        notDoneLabel.text = "\(notDoneCount)"
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
        cell.titleLabel.text = tasks[indexPath.row]
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
