//
//  CardCell.swift
//  ToDoList
//
//  Created by Student8 on 16/08/2024.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var isCheckmarkVisible: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtonAction()
    }
    
    
    func setupButtonAction() {
        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
            if isCheckmarkVisible {
                checkButton.setImage(UIImage(), for: .normal)
            } else {
                checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            }
           
            isCheckmarkVisible.toggle()
        }

}
