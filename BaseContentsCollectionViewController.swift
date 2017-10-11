
import UIKit



class BaseContentsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    // UI
    lazy var refreshControl: UIRefreshControl = {
        let c = UIRefreshControl()
        c.addTarget(self, action: #selector(fetchContents), for: .valueChanged)
        return c
    }()
    
    let customActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    
    // System
    var currentPage: Int = 1
    var appendingContentsBeingLoaded: Bool = false
    
    
    
    
    
    
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        collectionView?.alwaysBounceVertical = true
    }
    
    func setupSubviews() {
        collectionView?.addSubview( refreshControl )
        collectionView?.addSubview( customActivityIndicator )
        
        customActivityIndicator.centerXAnchor.constraint(equalTo: collectionView!.centerXAnchor).isActive = true
        //customActivityIndicator.centerXAnchor.constraint(equalTo: collectionView!.centerXAnchor ).active = true
        collectionView?.addConstraintsWithFormat(format: "V:|-20-[v0]", views: customActivityIndicator)
    
    }
    
    
    
    
    
    // MARK: Action
    
    func fetchContents( _ spinActivityIndicator: Bool ) {
        print("fetchContents not implemented.  Override it to implement")
    }
    
    func appendContentsByFetchingNextPage() {
        print("appendContentsByFetchingNextPage not implemented.  Override it to implement")
    }

    
    
    func startRefreshAnimation(_ useCustomActivityIndicator: Bool) {
        useCustomActivityIndicator ? customActivityIndicator.startAnimating() : refreshControl.beginRefreshing()
    }
    
    func stopRefreshAnimation() {
        customActivityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    
    
    
    
    
    
    
    // MARK: Event
    
    func scrollViewPulledAtBottom(_ scrollView: UIScrollView) {
        appendContentsByFetchingNextPage()
    }
    
    
    
    
    
    // MARK: Helper
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Code to detect scrollViewPuledAtBottom
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            scrollViewPulledAtBottom(scrollView)
        }
    }
}
