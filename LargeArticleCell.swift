
import UIKit


class LargeArticleCell: BaseArticleCell {
    
    // MARK: - Setup Subview
    // ここでセルのautolayoutをコードで作成
    override func setupViews() {
     
        super.setupViews()
        
        let imageViewWidth  = LargeArticleCell.imageViewWidth(forCellWidth: frame.width)
        let imageViewHeight = AspectRatio.articleImageHeight(forWidth: imageViewWidth)
        
        let horizontalMargin = 16
        
        // X: Image View
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 1) )
        addConstraintsWithFormat(format: "H:[v0(\(imageViewWidth))]",       views: thumbnailImageView)
        addConstraintsWithFormat(format: "V:|-16-[v0(\(imageViewHeight))]", views: thumbnailImageView)
        
        
        
        
        // Title Label
        let titleLableHeight: CGFloat = 40
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top,    relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8                ))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left,   relatedBy: .equal, toItem: thumbnailImageView, attribute: .left,   multiplier: 1, constant: 0                ))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right,  relatedBy: .equal, toItem: favoriteButton,     attribute: .left,   multiplier: 1, constant: 0               ))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil,                attribute: .height, multiplier: 0, constant: titleLableHeight ))
        
        
        // Favorite Button
        let favoriteButtonWidth: CGFloat = 54 // Marign(16) + Original Width(30) + Space to title lable(8)
        addConstraint(NSLayoutConstraint(item: favoriteButton, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 0))
        favoriteButton.widthAnchor.constraint(equalToConstant: favoriteButtonWidth).isActive = true
        addConstraint(NSLayoutConstraint(item: favoriteButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: favoriteButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        setFavoriteButtonImageInset()
        
        
        // Subviews of Thumbnail Image View
        setupSubviewOfThumbnailImageView()
        
        
        // Separator
        addConstraintsWithFormat(format: "H:|[v0]|",   views: separatorView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: separatorView)
    }
    
    func setupSubviewOfThumbnailImageView() {
        thumbnailImageView.addSubview(subtitleTextView)
        thumbnailImageView.addSubview(noImageLabel)
        
        thumbnailImageView.addConstraintsWithFormat(format: "H:|-6-[v0(200)]", views: subtitleTextView)
        thumbnailImageView.addConstraintsWithFormat(format: "V:|-6-[v0(20)]",  views: subtitleTextView)
        
        thumbnailImageView.addConstraintsWithFormat(format: "H:|-20-[v0(200)]", views: noImageLabel)
        thumbnailImageView.addConstraintsWithFormat(format: "V:[v0(50)]-20-|", views: noImageLabel)
    }
    
    func setFavoriteButtonImageInset() {
        favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    
    
    
    // MARK: - Helpser
    
    fileprivate static func imageViewWidth(forCellWidth cellWidth: CGFloat) -> CGFloat {
        
        let horizontalMargin: CGFloat = 16
        let imageViewWidth = cellWidth - ( horizontalMargin * 2 )
        return imageViewWidth
    }
    
    
    
    override class func height(forCellWidth cellWidth: CGFloat) -> CGFloat { // レイアウトにあったセルの高さを取得しているが、本来はautolayout及びUITableViewAutodimention等で対応すべき
        
        // Calcualte ImageView Height
        let imageViewWidth = LargeArticleCell.imageViewWidth(forCellWidth: cellWidth)
        let imageViewHeight = AspectRatio.articleImageHeight(forWidth: imageViewWidth)
        
        let utilitySpace: CGFloat = 70
        
        return imageViewHeight + utilitySpace
    }
}
