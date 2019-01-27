import Foundation
import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func commonInit() {

        contentView.addSubview(photoImageView)
        layoutComponents()
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(for item: Photo) {
        photoImageView.image = nil
        photoImageView.image = UIImage(named: "photoDefault")
        if let url = item.photoUrl {
            photoImageView.downloadedFrom(url: url)
        }
    }
}
