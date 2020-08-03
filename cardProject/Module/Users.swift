import UIKit


struct users : ProducesCardViewModel {
    let userName : String
    let proffesion : String
    let age : Int
    let imageNames : [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: userName,attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .heavy)])
        
            attributedText.append(NSMutableAttributedString(string: "  \(age)\n",attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
            attributedText.append(NSMutableAttributedString(string: proffesion,attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageName: imageNames, attributedString: attributedText, textAligment: .left)

    }
}


