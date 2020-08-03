import UIKit

class cardView: UIView {

    
    //encapsulation
   fileprivate let pointForOffSceane : CGFloat  = 80
    
    
    // constants
   fileprivate let gradientLayer = CAGradientLayer()
   fileprivate let informationLabel  = UILabel()
   fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "KZ3"))
   fileprivate var barsStackView = UIStackView()
   fileprivate var imageIndex = 0
   fileprivate let barSelectedColor = UIColor(white: 0, alpha: 0.1)
    
    
    // informationText
   fileprivate func setUpLayouts() {
        layer.cornerRadius = 9
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 9, bottom: 9, right: 9))
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 22, weight: .light)
    }
    
    
    // TapGesture CardViewModel
    var cardViewM : CardViewModel! {
        didSet {
            let Name = cardViewM.imageName.first ?? ""
            imageView.image = UIImage(named: Name)
            informationLabel.attributedText = cardViewM.attributedString
            informationLabel.textAlignment = cardViewM.textAligment
            
            (0..<cardViewM.imageName.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                barsStackView.addArrangedSubview(barView)
                
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setUpImageObserver()
        }
        
    }
    
    fileprivate func setUpImageObserver() {
        cardViewM.imageIndexObserver =  {[weak self] (idx, img) in
           // print("Chan")
            self?.imageView.image = img
            //self.barsStackView = self.barSelectedColor
            
            self?.barsStackView.arrangedSubviews.forEach ({ (v) in
                v.backgroundColor = self?.barSelectedColor
            })
            self?.barsStackView.arrangedSubviews[idx].backgroundColor = .white
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        addSubview(imageView)
        // image in CardVeiw
        imageView.fillSuperview()
        
        // setUpGradientLayer
        setUpGradientLayer()
        
        // setupBarsStackView
        setupBarsStackView()
        
        // informationLabel in CardView
        addSubview(informationLabel)
        
        setUpLayouts()
        
        // Gesture all CardView
        let handleGesture = UIPanGestureRecognizer(target: self, action: #selector(cardVmGesture))
        addGestureRecognizer(handleGesture)
        
        //addingTapGesture
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

    }
    
    @objc fileprivate func handleTap(gesture : UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvance = tapLocation.x > frame.width/2 ? true : false
        
        if shouldAdvance {
            cardViewM.advancetoNextPhoto()
        }
        else {
            cardViewM.advacePreviousPhoto()
        }
        
    }
    
    //setUpGradientLayer
    fileprivate func setUpGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        layer.addSublayer(gradientLayer)
    }
    
    //setUpBarStackView
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8,left: 8,bottom: 0,right: 8),size: .init(width: 0, height: 3))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    
    // animation Changed
    fileprivate func Changed(_ translaition: CGPoint) {
        let degres : CGFloat = translaition.x / 15
        let angle = degres * .pi / 180
        self.transform = CGAffineTransform(rotationAngle: angle).translatedBy(x: translaition.x, y: translaition.y)
    }
    // animation Ended
    fileprivate func Ended(_ translaition: CGPoint) {
        let dissmis = abs(translaition.x) > self.pointForOffSceane
        let x = translaition.x > 0 ? 1 : -1
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            if dissmis {
                let transformDissMis = self.transform.translatedBy(x: CGFloat(1000 * x)
                    , y: 0)
                self.transform = transformDissMis
                
            }
            else {
                self.transform = .identity
            }
        }) { (_) in
            
            // self.transform = .identity
            if dissmis {
                self.removeFromSuperview()
            }
        }
    }
    // function for animation
    @objc fileprivate func cardVmGesture(gesture : UIPanGestureRecognizer) {
        let translaition = gesture.translation(in: nil)
        
        switch gesture.state {
        case .began:
            
            // fix bags on animations
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            Changed(translaition)
        case .ended :
            Ended(translaition)
            
        default:
            ()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
