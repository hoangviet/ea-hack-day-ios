import UIKit

class MoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    
    func configure(#stock: String, price: NSNumber, changePercent: CFloat) {
        stockLabel.text         = stock
        priceLabel.text         = "\(price.currency)"
        changePercentLabel.text = "\(changePercent)%"
    }
}
