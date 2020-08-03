import UIKit

class bottomStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame : frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        let buttonStack = [#imageLiteral(resourceName: "3 1.png"),#imageLiteral(resourceName: "3 2"),#imageLiteral(resourceName: "3 3"),#imageLiteral(resourceName: "3 4"),#imageLiteral(resourceName: "3 5")].map { (v) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(v.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        buttonStack.forEach { (add) in
            addArrangedSubview(add)
        }
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
