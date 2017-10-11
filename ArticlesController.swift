
import UIKit

enum ArticlesControllerDaraSourceState {
    case feed
    case favorite
}

class ArticlesController: BaseContentsCollectionViewController {

    // MARK: - Property
    
    // MARK: Cell
    var state        : ArticlesControllerDaraSourceState = .feed
    
    
    // Cell ID
    private let largeCellId  = "LargeArticleCell"
    private let smallCellId  = "SmallArticleCell"
    private let headerCellId = "HeaderCellId"
    
    
    // Cell Class
    typealias largeCellClass = LargeArticleCell
    typealias smallCellClass = SmallArticleCell
    
    
    // MARK: Presentaito Logic
    var lastContentOffsetFeed    : CGPoint = CGPoint.zero
    var lastContentOffsetFavorite: CGPoint = CGPoint.zero
    
    
    // MARK: No contents message
    let noContentsMessageLabel: UILabel = {
        let l = UILabel()
        l.setTranslatesAutoresizingMaskIntoConstraintsToFalse()
        l.text  = "No Contents"
        l.textColor = .lightGray
        l.isHidden = true
        return l
    }()
    
    
    // MARK: Model
    var tags    : [String]  = [] { didSet {
        if tags.count != 0 {
            title = String(texts: tags, separator: " ")
        } else {
            title = SightsText.allArticlesTab
        }
        fetchContents(true)
    } }
    
    var feedArticles    : [Article] = [] { didSet {
        collectionView?.reloadData()
        updateNocontentsDisplayLabelIsHidden()
    } }
    
    var favoriteArticles: [Article] = [] { didSet {
        collectionView?.reloadData()
        updateNocontentsDisplayLabelIsHidden()
    } }
    
    
    
    
    
    
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView?.register(largeCellClass.self, forCellWithReuseIdentifier: largeCellId)
        collectionView?.register(smallCellClass.self, forCellWithReuseIdentifier: smallCellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellId)
        collectionView?.backgroundColor = .white
    }

    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview( noContentsMessageLabel )
        
        noContentsMessageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noContentsMessageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    
    
    
    
    
    
    // MARK: - Scrolls to top control
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.scrollsToTop = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.scrollsToTop = false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log.info("number of items for \(String(describing: title))")
        switch state {
        case .feed:
            return self.feedArticles.count
            
        case .favorite:
            return self.favoriteArticles.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: BaseArticleCell
        
        switch state {
        case .feed:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! largeCellClass // 失敗の場合は、あえて！ でクラッシュさせてテスト時にすぐにわかるようにしている。
            cell.article = feedArticles[indexPath.row]
            
        case .favorite:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! smallCellClass
            cell.article = favoriteArticles[indexPath.row]
        }

        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Delegate
    
    // MARK: Size layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        
        switch state {
        case .feed:
            return CGSize(width: width, height: largeCellClass.height(forCellWidth: width) )
            
        case .favorite:
            return CGSize(width: width, height: smallCellClass.height(forCellWidth: width) )
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    // MARK: Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath)
        
        header.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1) // Default header color same as UITableView source by Stackoverflow https://stackoverflow.com/questions/8742493/what-is-the-default-tableview-section-header-background-color-on-the-iphone
        
        let label: UILabel = UILabel()
        label.text = "お気に入り"
        label.font = UIFont.systemFont(ofSize: 14) //UIFont.boldSystemFont(ofSize: 14)
        
        header.addSubview( label )
        header.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: label)
        header.addConstraintsWithFormat(format: "V:|[v0]|", views: label)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width: CGFloat = view.frame.width
        switch state {
        case .feed:
            return CGSize(width: width, height: 0)
            
        case .favorite:
            return CGSize(width: width, height: 24)
        }
    }
    
    
    
    // MARK: Last content offset
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) { // Save last content offset Y for switching data source state
        
        let currentContentOffsetY = scrollView.contentOffset.y
        let contentOffsetToStore: CGPoint

        if currentContentOffsetY >= 0 {
            contentOffsetToStore = scrollView.contentOffset
        } else {
            contentOffsetToStore = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
        
        
        switch state {
        case .feed:
            lastContentOffsetFeed     = contentOffsetToStore
            
        case .favorite:
            lastContentOffsetFavorite = contentOffsetToStore
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let article = articleForCurrentState(andIndex: indexPath.row)
        let browser = ArticleBrowserController.makeBrowser(withArticle: article)
        navigationController?.pushViewController(browser, animated: true)
        
        
        
        FAEventSend.articleView(article: article)
        switch state {
        case .feed:
            FAEventSend.articleViewFromFeed(article: article)
        case .favorite:
            FAEventSend.articleViewFromFavorite(article: article)
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Action
    
    func changeDataSource(toState newState: ArticlesControllerDaraSourceState) {
        
        guard newState != self.state else { return }
        
        switch newState {
        case .feed:
            // Switch to Feed State

            log.info("Switching to Feed state")
            state = .feed
            collectionView?.reloadData()
            collectionView?.setContentOffset(lastContentOffsetFeed, animated: false)
            updateNocontentsDisplayLabelIsHidden()
            
        case .favorite:
            // Switch to Favorite State
            log.info("Switching to Favorite state")
            state = .favorite
            fetchFavoriteContents(true)
            collectionView?.setContentOffset(lastContentOffsetFavorite, animated: false)
            updateNocontentsDisplayLabelIsHidden()
        }
        
    }
    
    override func fetchContents(_ spinActivityIndicator: Bool) {
        switch state {
        case .feed:
            fetchFeedContents(spinActivityIndicator)
        case .favorite:
            fetchFavoriteContents(spinActivityIndicator)
        }
    }
    
    func updateNocontentsDisplayLabelIsHidden() {
        switch state {
        case .feed:
            if feedArticles.count == 0 {
                noContentsMessageLabel.isHidden = false
            } else {
                noContentsMessageLabel.isHidden = true
            }
            
        case .favorite:
            if favoriteArticles.count == 0 {
                noContentsMessageLabel.isHidden = false
            } else {
                noContentsMessageLabel.isHidden = true
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Action Helper
    
    func fetchFeedContents(_ spinActivityIndicator: Bool) {
        startRefreshAnimation(spinActivityIndicator)
        log.info("Start loading feed articles...")
        
        Article.Server.V1.index(tags: self.tags, completion: { isSuccess, articles in
            self.feedArticles = articles
            self.stopRefreshAnimation()
            log.info("Finish loading articles")
            log.info("Articles for \(String(describing: self.title)): \(articles.count)")
        })
    }
    
    func fetchFavoriteContents(_ spinActivityIndicator: Bool) {
        log.info("Start loading favorite articles...")
        favoriteArticles = Article.DB.articles(forTags: self.tags)
        self.stopRefreshAnimation()
    }
    
    
    
    func articleForCurrentState(andIndex index: Int) -> Article {
        
        switch state {
        case .feed:
            return feedArticles[index]
            
        case .favorite:
            return favoriteArticles[index]
        }
    }
}






// MARK: - Factory

extension ArticlesController {
    static func makeController(withTags tags: [String]) -> ArticlesController {
        let vc = ArticlesController(collectionViewLayout: UICollectionViewFlowLayout() )
        vc.tags = tags
        vc.fetchContents(true)
        return vc
    }
}
