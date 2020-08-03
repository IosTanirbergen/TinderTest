import UIKit

class HomeViewController: UIViewController {
    let topMenuStack = topStackView()
    let mainView = UIView()
    let bottomMenuStack = bottomStackView()
    let cardViewModel = ([
        users(userName: "Dayana", proffesion: "Designer", age: 27, imageNames:  ["AZ2","AZ3"]),
        users(userName: "Aidana", proffesion: "Singer", age: 25, imageNames: ["KZ3","KZ2"]),
        Advertiser(title: "StiveJobs", brandName: "Apple", posterPhotoName: "advertiser")
        
        ] as [ProducesCardViewModel]).map { (producer) -> CardViewModel in
            return producer.toCardViewModel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            topMenuStack.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        //mainView.backgroundColor = .green
        addHomeController()
        addCardView()

        
        
    }
    @objc fileprivate func handleSettings() {
        print("Show Registraion Page")
        let registrationController = RegistrationController()
        present(registrationController,animated: true)
    }
    
    fileprivate func addCardView() {
        cardViewModel.forEach { (cardVM) in
            let cardV = cardView(frame : .zero)
            cardV.cardViewM = cardVM
            mainView.addSubview(cardV)
            cardV.fillSuperview()
            
        }
        
    }
    fileprivate func addHomeController() {
         let homeStackView = UIStackView(arrangedSubviews: [topMenuStack,mainView,bottomMenuStack])
         homeStackView.axis = .vertical
         view.addSubview(homeStackView)
          homeStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        homeStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        homeStackView.isLayoutMarginsRelativeArrangement = true
        homeStackView.bringSubviewToFront(mainView)
         homeStackView.fillSuperview()
         
     }


}

