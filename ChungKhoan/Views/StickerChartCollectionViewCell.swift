import UIKit
import FSLineChart

class StickerChartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var chartView: FSLineChart!
    @IBOutlet var withinButtons: [UIButton]!
    var viewModel: StickerChartViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.chartView.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.width, self.chartView.frame.height)
        self.chartView.fillColor = UIColor.redColor()
        self.chartView.innerGridColor = UIColor.redColor()
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
        self.withinButtons.first?.selected = true
    }

    func bindViewModel(viewModel: StickerChartViewModel) {
        if self.viewModel == nil {
            self.viewModel = viewModel
            self.refresh()
        }
    }

    func refresh() {
        self.viewModel.getStickerPrices().start(next: { [weak self] _ in
            if let weakSelf = self {
                for subview in weakSelf.chartView.subviews  {
                    if let view = subview as? UIView {
                        view.removeFromSuperview()
                    }
                }
                weakSelf.chartView.clearChartData()
                weakSelf.chartView.setChartData(weakSelf.viewModel.prices)
            }
        })
    }

    @IBAction func withinButtonDidTouch(sender: UIButton) {
        self.viewModel.setWithinWithTag(sender.tag)
        self.withinButtons.map { $0.selected = false }
        sender.selected = true
        self.refresh()
    }
}
