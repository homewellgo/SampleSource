
import UIKit
import RealmSwift

class ArticleEntiry: Object {

    dynamic var id          : Int       = 0
    dynamic var title       : String    = ""
    dynamic var URL         : String    = ""
    dynamic var thumbnailURL: String?
    dynamic var siteName    : String    = ""
    dynamic var savedAt     : NSDate?
    
    let tags = List<TagEntity>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    convenience init(
        id          : Int,
        title       : String,
        URL         : String,
        thumbnailURL: String?,
        siteName    : String,
        savedAt     : NSDate?,
        tags        : [String]
        ) {
        self.init()
        
        self.id           = id
        self.title        = title
        self.URL          = URL
        self.thumbnailURL = thumbnailURL
        self.siteName     = siteName
        self.savedAt      = savedAt
        
        for tagString in tags {
            if let tagEntity = TagEntity.findOrCreate(byName: tagString) {
                self.tags.append( tagEntity )
            }
        }
        
    }
    
    
    
    // Entity to Article Coversion
    var makeArticle: Article {
        let article = Article(
            id:         self.id,
            title       : self.title,
            URL         : self.URL,
            thumbnailURL: self.thumbnailURL,
            siteName    : self.siteName,
            savedAt     : self.savedAt as Date?,
            tags: tags.map({ return $0.name }),
            isFavorite  : true
        )
        article.isFavorite = true
        return article
    }
}





extension ArticleEntiry {
    typealias SelfType = ArticleEntiry
    
    
    // MARK: save & delete
    
    func save() -> Bool {
        
        guard findSelf() == nil else {
            log.info("Attempt to save Article with exsisting primary key:\(self.id). Save failed.")
            return false
        }
        
        log.info("saving", self.title)
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add( self )
            }
            return true
            
        } catch {
            return false
        }
    }
    
    
    static func delete(id: Int) -> Bool {
        
        guard let deletingObject = SelfType.find(id: id) else { return false }
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(deletingObject)
            }
            return true
            
        } catch {
            return false
        }
    }
    
    
    
    // MARK: Get
    
    static func find(id: Int) -> SelfType? {

        do {
            let realm = try Realm()
            return realm.object(ofType: SelfType.self, forPrimaryKey: id as AnyObject)
        } catch {
            return nil
        }
    }
    
    
    static func articles(forTags tags: [String]) -> [ArticleEntiry] {
        
        do {
            let realm = try Realm()
            
            var articles = Array(realm.objects(SelfType.self))
            
            for tag in tags {
                articles = filter(article: articles, byTag: tag)
            }
            
            return articles
            
        } catch {
            return []
        }
    }
    
    
    
    
    // MARK: Helper
    
    private func findSelf() -> SelfType? {
        return SelfType.find(id: self.id)
    }
    
    fileprivate static func filter(article: [ArticleEntiry], byTag tag: String ) -> [ArticleEntiry] {
        return article.filter({ $0.tags.contains(where: { $0.name == tag }) })
    }
}





