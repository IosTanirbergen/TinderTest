
import UIKit

class topStackView: UIStackView {
    let settingButton = UIButton(type: .system)
    let fireImage = UIImageView(image: #imageLiteral(resourceName: "3 7"))
    let messageButton = UIButton(type: .system)
    override init(frame: CGRect) {
        super.init(frame : frame)
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        settingButton.setImage(#imageLiteral(resourceName: "3 6").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "3 8").withRenderingMode(.alwaysOriginal), for: .normal)
        [settingButton,fireImage,messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        fireImage.contentMode = .scaleAspectFit
        distribution = .equalCentering
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
