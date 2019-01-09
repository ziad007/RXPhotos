import Foundation
import UIKit

class LoadingCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var loadingLabel: UILabel! {
        didSet {
            loadingLabel.text = "Loading.."
        }
    }
    static let Height: CGFloat = 82
}
