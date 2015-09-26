import UIKit
import RealmSwift

class OverviewViewController: UIViewController {
    @IBOutlet weak var moversCollectionView: UICollectionView!
    @IBOutlet weak var totalAssetLabel: UILabel!
    @IBOutlet weak var portfolioGainLabel: UILabel!

    private let moverReuseIdentifier = "MoverCell"
    private enum MoverType: Int {
        case Up, Down
    }
    
    var currentDevice: Device? = nil {
        didSet {
            if let currentDevice = currentDevice {
                self.totalAssetLabel.text    = "\(currentDevice.totalAsset.currency)"
                self.portfolioGainLabel.text = "\(currentDevice.portfolioGain.currency) (--%)"
                self.movers = currentDevice.stickers
                var upIdx = 0
                var downIdx = 0
                self.moversMask = [[Int]]()
                for (idx, mover) in enumerate(self.movers) {
                    if (mover.reference_price > 0) {
                        if (upIdx > self.moversMask.count - 1) {
                            self.moversMask.insert([-1, -1], atIndex: upIdx)
                        }
                        self.moversMask[upIdx][0] = idx
                        upIdx++
                    } else {
                        if (downIdx > self.moversMask.count - 1) {
                            self.moversMask.insert([-1, -1], atIndex: downIdx)
                        }
                        self.moversMask[downIdx][1] = idx
                        downIdx++
                    }
                }
                self.moversCollectionView.reloadData()
            }
        }
    }
    var movers = List<DeviceSticker>()
    var moversMask = [[Int]]()
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addStickerToPortfolio:"), name: "DidAddStickerToPortfolio", object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        DeviceService.fetchStickers(device: DeviceService.currentDevice(), success: { [weak self] (device) -> Void in
            if let weakSelf = self {
                weakSelf.currentDevice = device
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! ==  "SegueStock") {
            var selectedSticker: Sticker!
            if let deviceSticker = sender as? DeviceSticker {
                selectedSticker = deviceSticker.sticker
            } else if let sticker = sender as? Sticker {
                selectedSticker = sticker
            }
            if selectedSticker != nil {
                let stockViewController = segue.destinationViewController as! StickerViewController
                stockViewController.sticker = selectedSticker
            }

        }
    }
    
    func addStickerToPortfolio(notification: NSNotification) {
        if let sticker = notification.object as? Sticker {
//            self.movers.append(sticker)
            var upIdx = 0
            var downIdx = 0
            self.moversMask = [[Int]]()
            for (idx, mover) in enumerate(self.movers) {
                if (true) {
                    if (upIdx > self.moversMask.count-1) {
                        self.moversMask.insert([-1, -1], atIndex: upIdx)
                    }
                    self.moversMask[upIdx][0] = idx
                    upIdx++
                } else {
                    if (downIdx > self.moversMask.count-1) {
                        self.moversMask.insert([-1, -1], atIndex: downIdx)
                    }
                    self.moversMask[downIdx][1] = idx
                    downIdx++
                }
            }
            self.moversCollectionView.reloadData()
            self.navigationController?.popToViewController(self, animated: true)
        }
    }
    
    @IBAction func addButtonDidTouch(sender: AnyObject) {
        let searchResultsController = storyboard!.instantiateViewControllerWithIdentifier(SearchResultsViewController.StoryboardConstants.identifier) as! SearchResultsViewController
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.barTintColor()
        searchController.searchBar.tintColor = UIColor.barForegroundColorColor()
        searchResultsController.didSelectResult = { (sticker: Sticker?) -> () in
            self.performSegueWithIdentifier("SegueStock", sender: sticker)
        }
        // Present the view controller.
        presentViewController(searchController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension OverviewViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let moverIdx = self.moversMask[indexPath.section][indexPath.row]
        self.performSegueWithIdentifier("SegueStock", sender: self.movers[moverIdx])
    }
}

// MARK: - UICollectionViewDataSource
extension OverviewViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.moversMask.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let moverIdx = self.moversMask[indexPath.section][indexPath.row]
        if moverIdx == -1 {
            return collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCell", forIndexPath: indexPath) as! MoverCollectionViewCell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(moverReuseIdentifier, forIndexPath: indexPath) as! MoverCollectionViewCell
        let sticker = self.movers[moverIdx]
        
        if let moverType = MoverType(rawValue: indexPath.row) {
            switch moverType {
            case .Up:
                cell.backgroundColor = .upBackgroundColor()
            case .Down:
                cell.backgroundColor = .downBackgroundColor()
            }
        }
        
        cell.configure(stock: sticker.name, price: sticker.reference_price, changePercent: 0)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OverviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width / 2.0, 72)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
    }
}
