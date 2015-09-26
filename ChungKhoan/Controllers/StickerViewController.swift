import UIKit

class StickerViewController: UIViewController {
    
    @IBOutlet weak var addOrRemoveButton: UIBarButtonItem!
    
    var sticker: Sticker?
    
    private let stickerInfoReuseIdentifier  = "ReuseIdentifierStickerInfo"
    private let stickerChartReuseIdentifier = "ReuseIdentifierChartInfo"
    private let stickerDataReuseIdentifier  = "ReuseIdentifierDataInfo"
    
    private enum StickerSections:Int {
        case Info = 0, Chart, Data
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.performSegueWithIdentifier("SegueAddToPortfolio", sender: sticker)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! ==  "SegueAddToPortfolio") {
            if let sticker = sender as? Sticker {
                let addPortfolioViewController = segue.destinationViewController as! AddToPortfolioViewController
                addPortfolioViewController.sticker = sticker
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension StickerViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        if let section = StickerSections(rawValue: indexPath.section) {
            switch section {
            case .Info:
                let infoCell = collectionView.dequeueReusableCellWithReuseIdentifier(stickerInfoReuseIdentifier, forIndexPath: indexPath) as! StickerInfoCollectionViewCell
                if let sticker = self.sticker {
                    var price:Float = 0.0
                    if let referencePrice = sticker.reference_price {
                        price = referencePrice.value
                    }
                    
                    infoCell.configure(
                        companyName: sticker.title,
                        companyDomain: "",
                        price: price,
                        change: 0,
                        changePercent: 0)
                }
                cell = infoCell
            case .Chart:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier(stickerChartReuseIdentifier, forIndexPath: indexPath)as! StickerChartCollectionViewCell
            case .Data:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier(stickerDataReuseIdentifier, forIndexPath: indexPath)as! StickerDataCollectionViewCell
            
            }
            
        }
        
        return cell!
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
