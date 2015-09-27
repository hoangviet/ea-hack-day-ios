import UIKit

class StickerViewController: UIViewController {
    private let stickerInfoReuseIdentifier  = "ReuseIdentifierStickerInfo"
    private let stickerChartReuseIdentifier = "ReuseIdentifierChartInfo"
    private let stickerDataReuseIdentifier  = "ReuseIdentifierDataInfo"
    private enum StickerSections:Int {
        case Info = 0, Chart, Data
    }

    @IBOutlet weak var addOrRemoveButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    var sticker: Sticker?
    var deviceSticker: DeviceSticker?
    var inAddingSticker: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        if let deviceSticker = self.deviceSticker {
            self.sticker = deviceSticker.sticker
            self.inAddingSticker = false
            if let image = UIImage(named: "Icon_Alert") {
                var settingButton = UIButton(frame: CGRectMake(0, 0, image.size.width, image.size.height))
                settingButton.setBackgroundImage(image, forState: UIControlState.Normal)
                settingButton.addTarget(self, action: Selector("addOrRemoveButtonDidTouch:"), forControlEvents: UIControlEvents.TouchUpInside)
                let barSettingButton = UIBarButtonItem(customView: settingButton)
                self.navigationItem.rightBarButtonItem = barSettingButton
            }

        }

        if let sticker = self.sticker {
            self.navigationItem.title = sticker.name
            // Sticker is not complete or outdate, It needs to fetch to fullfill
            StickerService.fetch(sticker: sticker, success: { [unowned self] (sticker) -> Void in
                self.sticker = sticker
                self.collectionView.reloadData()
            })
            self.collectionView.registerNib(UINib(nibName: "StickerInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.stickerInfoReuseIdentifier)
            self.collectionView.registerNib(UINib(nibName: "StickerChartCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.stickerChartReuseIdentifier)
            self.collectionView.registerNib(UINib(nibName: "StickerDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.stickerDataReuseIdentifier)
            self.collectionView.addPullToRefreshWithActionHandler { () -> Void in
                self.collectionView.pullToRefreshView.stopAnimating()
            }
        }
    }
    
    @IBAction func addOrRemoveButtonDidTouch(sender: AnyObject) {
        if self.inAddingSticker {
            self.performSegueWithIdentifier("SegueAddToPortfolio", sender: sticker)
        } else {
            self.performSegueWithIdentifier("SegueSetting", sender: sticker)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sticker = sender as? Sticker, let identifier = segue.identifier  {
            switch identifier {
            case "SegueAddToPortfolio":
                let addPortfolioViewController = segue.destinationViewController as! AddToPortfolioViewController
                addPortfolioViewController.sticker = sticker
            case "SegueSetting":
                let settingViewController = segue.destinationViewController as! SettingViewController
                settingViewController.stickerID = sticker.name
            default:
                break
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension StickerViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let section = StickerSections(rawValue: indexPath.section), let sticker = self.sticker {
            switch section {
            case .Info:
                let infoCell = collectionView.dequeueReusableCellWithReuseIdentifier(stickerInfoReuseIdentifier, forIndexPath: indexPath) as! StickerInfoCollectionViewCell
                if let sticker = self.sticker {
                    var price: NSNumber = 0.0
                    if let referencePrice = sticker.reference_price {
                        price = referencePrice.price
                    }
                    
                    infoCell.configure(
                        companyName: sticker.title,
                        companyDomain: "",
                        price: price,
                        change: 0,
                        changePercent: 0)
                }
                return infoCell
            case .Chart:
                let chartCell = collectionView.dequeueReusableCellWithReuseIdentifier(stickerChartReuseIdentifier, forIndexPath: indexPath) as! StickerChartCollectionViewCell
                chartCell.bindViewModel(StickerChartViewModel(stickerID: sticker.name))
                return chartCell
            case .Data:
                return collectionView.dequeueReusableCellWithReuseIdentifier(stickerDataReuseIdentifier, forIndexPath: indexPath)as! StickerDataCollectionViewCell
            }
        }

        return UICollectionViewCell()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let section = StickerSections(rawValue: indexPath.section) {
            switch section {
            case .Info:
                return CGSizeMake(collectionView.frame.width, 95)
            case .Chart:
                return CGSizeMake(collectionView.frame.width, 220)
            case .Data:
                return CGSizeMake(collectionView.frame.width, 180)
            default:
                return CGSizeZero
            }
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
    }
}
