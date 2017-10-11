
import UIKit
import Kingfisher

class BaseArticleCell: UICollectionViewCell {
    
    // MARK: Subview
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.backgroundColor = UIColor(red: 233/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "text not found"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.ymTextWhite()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 9)
        return textView
    }()
    
    lazy var favoriteButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTranslatesAutoresizingMaskIntoConstraintsToFalse()
        b.addTarget(self, action: #selector(favoriteButtonTap), for: .touchDown)
        b.tintColor = UIColor.clear
        b.setImage(UIImage(named: "BookmarkTagNormal"  )?.withRenderingMode(.alwaysOriginal), for: UIControlState() )
        b.setImage(UIImage(named: "BookmarkTagSelected")?.withRenderingMode(.alwaysOriginal), for: .selected)
        return b
    }()
    
    let noImageLabel: UILabel = {
        let l = UILabel()
        l.text = "No Image"
        l.textColor = UIColor.lightText
        l.font = UIFont.systemFont(ofSize: 40)
        return l
    }()
    
    
    
    
    // MARK: Model
    
    var article: Article? {
        didSet {
            
            
            guard let a = article else {
                thumbnailImageView.image    = nil
                subtitleTextView.text       = ""
                titleLabel.text             = ""
                favoriteButton.isSelected     = false
                return
            }
            
            self.titleLabel.text = a.title
            subtitleTextView.text = a.siteName
            favoriteButton.isSelected = a.isFavorite
            
            
            
            
            if let urlString = a.thumbnailURL, let url = URL(string: urlString)  {
                setThumbnailImageViewStateImageFound(url)
            } else {
                setThumbanilImageViewStateImageNotFound()
            }
        }
    }
    
    #if DEV
    func setHttpStyle(url: String?) {
        guard let url = url else {
            thumbnailImageView.layer.borderWidth = 4
            thumbnailImageView.layer.borderColor = UIColor.black.cgColor
            return
        }
        
        if url.hasHttpsPrefix {
            thumbnailImageView.layer.borderWidth = 4
            thumbnailImageView.layer.borderColor = UIColor.blue.cgColor
        } else {
            thumbnailImageView.layer.borderWidth = 4
            thumbnailImageView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    #endif
    
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(titleLabel)
        addSubview(favoriteButton)
    }
    
    
    
    
    
    
    
    // MARK: Event
    
    func favoriteButtonTap() {

        let chageToIsFavorite = !favoriteButton.isSelected
        
        favoriteButton.isSelected = chageToIsFavorite
        article?.isFavorite = chageToIsFavorite
        
        if chageToIsFavorite {
            let _ = article?.saveToDB()
        } else {
            let _ = article?.deleteFromDB()
        }
    }
    
    
    
    
    
    // MARK: Thumbnail Image View State
    
    func setThumbnailImageViewStateImageFound(_ url: URL) {
        noImageLabel.isHidden = true
        thumbnailImageView.backgroundColor = UIColor.clear
        thumbnailImageView.kf.setImage(with: url)
    }
    
    func setThumbanilImageViewStateImageNotFound() {
        thumbnailImageView.image = nil
        thumbnailImageView.backgroundColor = UIColor.rgb(red: 240, green: 230, blue: 230)
        noImageLabel.isHidden = false
    }
    
    
    
    
    // Height Getter
    class func height(forCellWidth cellWidth: CGFloat) -> CGFloat { // レイアウトにあった高さを計算させるメソッドだが、NG.  本来はUITasbleViewAutodimensionと、cell内のautolayoutで対応すべき。
        fatalError("This is an abstruct class")
    }
    
    
}
