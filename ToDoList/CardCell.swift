
import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var isCheckmarkVisible: Bool = false {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("checkmarkChanged"), object: nil)
        }
    }
    
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
