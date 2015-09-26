import UIKit

class MoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    
    func configure(#stock: String, price: CFloat, changePercent: CFloat) {
        stockLabel.text         = stock
        priceLabel.text         = "\(price)đ"
        changePercentLabel.text = "\(changePercent)%"
    }
}
