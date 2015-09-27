import UIKit
import MBProgressHUD

class AddToPortfolioViewController: UIViewController {
    @IBOutlet weak var updateButtonVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var sharesTextField: UITextField!
    @IBOutlet weak var unitPrice: UITextField!

    var viewModel: AddStickerViewModel!
    var sticker: Sticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sticker = self.sticker {
            self.viewModel = AddStickerViewModel(stickerID: sticker.name)
            sharesTextField.becomeFirstResponder()
            if let referencePrice = sticker.reference_price {
                unitPrice.text = "\(referencePrice.value)"
            }
            self.bindViewModel()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }

    func bindViewModel() {
        self.sharesTextField.rac_textSignal().toSignalProducer().start(next: { [weak self] text in
            if let weakSelf = self, let text: AnyObject = text {
                weakSelf.viewModel.quantity = text.integerValue
            }
        })
        self.unitPrice.rac_textSignal().toSignalProducer().start(next: { [weak self] text in
            if let weakSelf = self, let text: AnyObject = text {
                weakSelf.viewModel.unitPrice = text.floatValue
            }
        })
    }
    
    func doAnimation(notification: NSNotification) {
        if let info: AnyObject = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] {
            UIView.animateWithDuration(info.doubleValue, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let info: AnyObject = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] {
            let keyboardFrame = info.CGRectValue()
            updateButtonVerticalSpaceConstraint.constant = keyboardFrame.size.height + 10
        }
        doAnimation(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        updateButtonVerticalSpaceConstraint.constant = 8
        doAnimation(notification)
    }
    
    //MARK: Events
    
    @IBAction func updateButtonDidTouch(sender: AnyObject) {
        if self.viewModel == nil {
            return
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.viewModel.addSticker().start(completed: { [weak self] _ in
            if let weakSelf = self {
                MBProgressHUD.hideHUDForView(weakSelf.view, animated: true)
                NSNotificationCenter.defaultCenter().postNotificationName("DidAddStickerToPortfolio", object: nil)
            }
            }, error: { [weak self] (error: NSError) -> Void in
            if let weakSelf = self {
                MBProgressHUD.hideHUDForView(weakSelf.view, animated: true)
                if let errorMessage = error.userInfo?[NSLocalizedDescriptionKey] as? String {
                    UIAlertController.show(weakSelf, title: "Không thể thêm vào danh mục", message: errorMessage)
                }
            }
        })
    }
    
}
