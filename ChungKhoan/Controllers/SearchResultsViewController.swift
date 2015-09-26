import UIKit
import RealmSwift

// MARK: - Search Result Cell
class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    
    func configure(sticker: Sticker) {
        self.name.text  = sticker.name
        self.title.text = sticker.title
    }
}

// MARK: - Result View Controller
class SearchResultsViewController: UITableViewController {
    @IBOutlet var resultTableView: UITableView!
    struct StoryboardConstants {
        static let identifier = "SearchResultsViewControllerIdentifier"
    }
    struct TableViewConstants {
        static let tableViewCellIdentifier = "SearchResultsCell"
    }
    var visibleResults: Results<Sticker>?
    var searchTimer: NSTimer?
    var didSelectResult: ((sticker: Sticker?) -> ())?
    var filterString: String? = nil {
        didSet {
            if filterString != nil && !filterString!.isEmpty {
                // Show loading indicator
                self.tableView.tableFooterView?.hidden = false
                StickerService.searchBy(query: self.filterString!, success: { (stickers) -> Void in
                    // Done, hide loading indicator
                    self.tableView.tableFooterView?.hidden = true
                    // Display result
                    self.visibleResults = stickers
                    self.tableView.reloadData()
                }, failure: { (_, _, _) -> Void in
                    self.tableView.tableFooterView?.hidden = true
                });
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoadingIndicator()
    }
    
    func setupLoadingIndicator() {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 50))
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        self.tableView.tableFooterView = view
        self.tableView.tableFooterView?.hidden = true
    }
}


// MARK - UITableViewDataSource
extension SearchResultsViewController : UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let visibleResults = self.visibleResults {
            return visibleResults.count
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(TableViewConstants.tableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let searchCell:SearchResultTableViewCell = cell as! SearchResultTableViewCell
        searchCell.configure(visibleResults![indexPath.row])
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sticker = visibleResults![indexPath.row]
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let didSelectResult = self.didSelectResult {
                didSelectResult(sticker: sticker)
            }
        })
    }
    
}

// MARK - UISearchResultsUpdating
extension SearchResultsViewController : UISearchResultsUpdating {
    // Is called by searchTimer to perform searching
    func performSearching(timer: NSTimer) {
        let searchController = timer.userInfo as! UISearchController
        // Observer of filterString will do querying api
        filterString = searchController.searchBar.text
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if !searchController.active {
            return
        }
        // Wait for user to finish typing
        if let searchTimer = searchTimer {
            searchTimer.invalidate()
        }
        searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.3,
            target: self,
            selector: Selector("performSearching:"),
            userInfo: searchController,
            repeats: false)
    }
    
}
