import UIKit

class StickerInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    
    func configure(#companyName: String, companyDomain: String, price: NSNumber, change: CFloat, changePercent: CFloat) {
        companyNameLabel.text = companyName
        if (price == 0) {
            priceLabel.text = "--"
        } else {
            priceLabel.text = "\(price.currency)"
        }
        changeLabel.text        = "\(change)"
        changePercentLabel.text = "\(changePercent)%"
    }
}
