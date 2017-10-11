
import UIKit


// autolayoutを書く場合のhelper.
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }


    func setTranslatesAutoresizingMaskIntoConstraintsToFalse() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


