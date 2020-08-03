
import UIKit
protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}
class CardViewModel {
    let imageName : [String]
    let attributedString : NSAttributedString
    let textAligment : NSTextAlignment
    
    init(imageName: [String],attributedString : NSAttributedString, textAligment : NSTextAlignment) {
        self.imageName = imageName
        self.attributedString = attributedString
        self.textAligment = textAligment
    }
    fileprivate var imageIndex = 0 {
        didSet{
            let imageNames = imageName[imageIndex]
            let image = UIImage(named: imageNames)
            imageIndexObserver?(imageIndex,image)
        }
    }
    // Reactive Programming
    
    var imageIndexObserver  :((Int,UIImage?) -> ())?
    
    func advancetoNextPhoto() {
        imageIndex = min(imageIndex + 1, imageName.count - 1)
    }
    func advacePreviousPhoto() {
        imageIndex = max(0,imageIndex - 1)
    }
    
    
}

