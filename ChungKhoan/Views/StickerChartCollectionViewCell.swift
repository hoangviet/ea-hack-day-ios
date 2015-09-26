import UIKit
import FSLineChart

class StickerChartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var chartView: FSLineChart!
    @IBOutlet var withinButtons: [UIButton]!
    var viewModel: StickerChartViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.chartView.labelForIndex = { [weak self] item in
            if let weakSelf = self {
                if let dates = weakSelf.viewModel.dates {
                    return dates[Int(item)]
                }
            }
            return ""
        }
        self.chartView.labelForValue = { [weak self] value in
            return "\(value)"
        }
    }

    func bindViewModel(viewModel: StickerChartViewModel) {
        self.viewModel = viewModel
        self.refresh()
    }

    func refresh() {
        self.viewModel.getStickerPrices().start(next: { [weak self] _ in
            if let weakSelf = self {
                weakSelf.chartView.setChartData(weakSelf.viewModel.prices)
            }
        })
    }

    @IBAction func withinButtonDidTouch(sender: UIButton) {
        self.viewModel.setWithinWithTag(sender.tag)
        self.refresh()
    }
}
