
import UIKit
import Firebase
import JGProgressHUD
class RegistrationController: UIViewController {
    let gradientLayer = CAGradientLayer()
    fileprivate func setupTopGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.transform = .identity
                    })
    }
    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
     }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        // you have a retain cycle
    }
    @objc fileprivate func handleKeyboardHide() {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                  self.view.transform = .identity
              })
    }
    @objc  fileprivate func handleKeyboardShow(notisfication : Notification){
      guard let value = notisfication.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - registrationStackView.frame.origin.y - registrationStackView.frame.height
        print(bottomSpace)

        let differnce = keyboardFrame.height - bottomSpace
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:{
        self.view.transform = CGAffineTransform(translationX: 0, y: -differnce - 10)
        })
     }
    
     lazy var verticalStackView : UIStackView = {
        let sv =  UIStackView(arrangedSubviews: [
                                     fullNameTextField,
                                     emailTextFiled,
                                     passwordTextFiled,
                                     registrationButton
                    ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
     }()
    
     lazy var registrationStackView = UIStackView(arrangedSubviews:
            [
             selectPhoto,
             verticalStackView
            ])
    
      override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        traitCollection.horizontalSizeClass
        if self.traitCollection.verticalSizeClass == .compact {
            registrationStackView.axis = .horizontal
        }
        else {
           self.registrationStackView.axis = .vertical
        }
      }
      fileprivate func setupRegistration() {
        
        view.addSubview(registrationStackView)
        registrationStackView.axis = .vertical
        selectPhoto.widthAnchor.constraint(equalToConstant: 275).isActive = true
        registrationStackView.spacing = 8
        registrationStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        registrationStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    @objc fileprivate func handleTextChange(textField : UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
            print("1sd")
        }
        else if textField == emailTextFiled {
            registrationViewModel.email = textField.text
            print("2sd")
        }
        else{
            registrationViewModel.password = textField.text
            print("3ps")
        }
    }
  
    
    // UI components
    let selectPhoto : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SelectPhoto", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    let fullNameTextField : UITextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let emailTextFiled : UITextField = {
           let tf = CustomTextField(padding: 16)
           tf.placeholder = "Enter Email"
           tf.keyboardType = .emailAddress
           tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
           tf.backgroundColor = .white
           return tf
       }()
    let passwordTextFiled : UITextField = {
           let tf = CustomTextField(padding: 16)
           tf.placeholder = "Enter password"
           tf.isSecureTextEntry = true
           tf.backgroundColor = .white
           tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
           return tf
       }()
    let registrationButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        button.backgroundColor = #colorLiteral(red: 0.8090223074, green: 0.09948729724, blue: 0.3270196915, alpha: 1)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for:.touchUpInside)
        return button
    }()

    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        guard let email = emailTextFiled.text else {return}
        guard let password = passwordTextFiled.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print(err)
                self.showHUBWithError(error: err)
                return
            }
            print("Successfully registered user :", res?.user.uid ?? "")
        }
    }
    fileprivate func showHUBWithError(error : Error) {
        let hub = JGProgressHUD(style: .dark)
        hub.textLabel.text = "Failed registration"
        hub.detailTextLabel.text = error.localizedDescription
        hub.show(in: self.view)
        hub.dismiss(afterDelay: 4)
    }
    override func viewDidLoad() {
          super.viewDidLoad()
         //view.backgroundColor = .red
           setupGradientLayer()
           setupRegistration()
           setupNotificationObserver()
           setupTopGesture()
           registrationViewModelObserver()
    }
    // MARK: -Private
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func registrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [unowned self]
            (isFormValid) in
            print("form is changing, is it valid?" ,isFormValid)
            
                    if isFormValid {
                        UIView.animate(withDuration: 1) {
                            self.registrationButton.backgroundColor = #colorLiteral(red: 0.8090223074, green: 0.09948729724, blue: 0.3270196915, alpha: 1)
                            self.registrationButton.setTitleColor(.white, for: .normal)
                            self.registrationButton.isEnabled = true
                        }
                    } else {
                        UIView.animate(withDuration: 1) {
                            self.registrationButton.backgroundColor = .lightGray
                            self.registrationButton.setTitleColor(.gray, for: .normal)
                            self.registrationButton.isEnabled = false
                        }
            }
        }
    }
    

       
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.982139647, green: 0.3621447086, blue: 0.3708251715, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.876845777, green: 0.1232967451, blue: 0.4402877688, alpha: 1)
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
    }

}
