import UIKit
import MBProgressHUD

class SettingViewController: UITableViewController {
    @IBOutlet weak var bottomPriceTextField: UITextField!
    @IBOutlet weak var ceilingPriceTextField: UITextField!

    var viewModel: SettingViewModel!
    var stickerID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let stickerID = self.stickerID {
            self.viewModel = SettingViewModel(stickerID: stickerID)
            self.bindViewModel()
        }
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
    }

    func bindViewModel() {
        self.bottomPriceTextField.rac_textSignal().toSignalProducer().start(next: { [weak self] text in
            if let weakSelf = self, let text: AnyObject = text {
                weakSelf.viewModel.bottom = text.floatValue
            }
        })
        self.ceilingPriceTextField.rac_textSignal().toSignalProducer().start(next: { [weak self] text in
            if let weakSelf = self, let text: AnyObject = text {
                weakSelf.viewModel.ceiling = text.floatValue
            }
        })
        self.viewModel.getPriceAlerts().start(next: { [weak self] _ in
            if let weakSelf = self {
                weakSelf.bottomPriceTextField.placeholder  = "\(weakSelf.viewModel.bottom)"
                weakSelf.ceilingPriceTextField.placeholder = "\(weakSelf.viewModel.ceiling)"
            }
        })
    }

    @IBAction func updateButtonDidTouch(sender: AnyObject) {
        if self.viewModel == nil {
            return
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.viewModel.createPriceAlerts().start(completed: { [weak self] _ in
            if let weakSelf = self {
                MBProgressHUD.hideHUDForView(weakSelf.view, animated: true)
                UIAlertController.show(weakSelf, title: "Đã lưu", message: "Thông tin cảnh báo giá đã được cập nhật")
            }
        }, error: { [weak self] _ in
            if let weakSelf = self {
                MBProgressHUD.hideHUDForView(weakSelf.view, animated: true)
            }
        })
    }
}
