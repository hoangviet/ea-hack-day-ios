import UIKit

class StickerInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyDomainLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    
    func configure(#companyName: String, companyDomain: String, price: CFloat, change: CFloat, changePercent: CFloat) {
        companyNameLabel.text   = companyName
        companyDomainLabel.text = companyDomain
        if (price == 0) {
            priceLabel.text = "--"
        } else {
            priceLabel.text = "\(price)đ"
        }
        changeLabel.text        = "\(change)"
        changePercentLabel.text = "\(changePercent)%"
    }
}
