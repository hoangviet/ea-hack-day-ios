import UIKit

class AddToPortfolioViewController: UIViewController {

    @IBOutlet weak var updateButtonVerticalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sharesTextField: UITextField!
    @IBOutlet weak var unitPrice: UITextField!
    
    var sticker: Sticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sticker = self.sticker {
            sharesTextField.becomeFirstResponder()
            if let referencePrice = sticker.reference_price {
                unitPrice.text = "\(referencePrice.value)"
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
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
        let device = DeviceService.currentDevice()
        if let sticker = self.sticker {
            let quantity = NSString(string: self.sharesTextField.text).integerValue
            let unitPrice = NSString(string: self.unitPrice.text).floatValue
            
            DeviceService.add(sticker: sticker, toDevice: device, quantity: quantity, unitPrice: unitPrice, success: { () -> Void in
                // Submit to api
                NSNotificationCenter.defaultCenter().postNotificationName("DidAddStickerToPortfolio", object: sticker)
                }) { (_, _, _) -> Void in
                    // TODO implement this
            }
        }
        
    }
    
}
