//
//  ViewController.swift
//  ToDoList
//
//  Created by Student8 on 16/08/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statesCardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statesCardView.layer.cornerRadius = 10
            statesCardView.layer.shadowColor = UIColor.black.cgColor
            statesCardView.layer.shadowOpacity = 0.2
            statesCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            statesCardView.layer.shadowRadius = 4
        //lllllllll
        // Do any additional setup after loading the view.
    }


}

