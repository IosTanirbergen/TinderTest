import UIKit


struct Advertiser : ProducesCardViewModel {
    let title : String
    let brandName : String
    let posterPhotoName : String
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title,attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSMutableAttributedString(string: "\n" + brandName,attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageName: [posterPhotoName] , attributedString: attributedString, textAligment: .center)
    }
}
