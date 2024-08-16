//
//  ViewController.swift
//  ToDoList
//
//  Created by Student8 on 16/08/2024.
//

import UIKit

class ViewController: UIViewController, UITabBarDelegate , UITableViewDataSource{

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
    }
    
    func initCardView(){
        statesCardView.layer.cornerRadius = 10
        statesCardView.layer.shadowColor = UIColor.black.cgColor
        statesCardView.layer.shadowOpacity = 0.2
        statesCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        statesCardView.layer.shadowRadius = 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        cell.titleLabel.text = tasks[indexPath.row]
        return cell
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
        }
    
    func updateTableViewHeight() {
            let contentHeight = cardTableView.contentSize.height
            tableViewHeightConstraint.constant = contentHeight
            view.layoutIfNeeded() // מרענן את הפריסה עם הגובה החדש
        }
    
    func updateTotalLabel() {
        totalLabel.text = "\(tasks.count)"
    }
    
}

