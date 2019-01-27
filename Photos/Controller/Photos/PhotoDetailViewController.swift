//
//  DetailViewController.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/23/17.
//  Copyright © 2017 ziad Bou Ismail. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel : UILabel!

    private let photo: Photo

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        titleLabel.text = photo.title

        if let url = photo.largePhotoUrl {
            photoImageView.downloadedFrom(url: url)
        }
    }

    private func setupNavigationItem() {
        navigationItem.title = ""
    }

    init(for photo: Photo) {
        self.photo = photo
        super.init(nibName: "PhotoDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
