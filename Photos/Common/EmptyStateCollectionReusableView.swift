import Foundation
import UIKit

class EmptyStateCollectionReusableView: UICollectionReusableView {
    var didUpdateConstraints = false

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "End of results"
        return label
    }()

    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        frame.size = CGSize(width: 999, height: 999)

        addSubview(titleLabel)
        layoutComponents()

    }

    private func layoutComponents() {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
    }
}
