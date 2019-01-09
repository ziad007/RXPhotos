//
//  ViewController.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/17/17.
//  Copyright © 2017 ziad Bou Ismail. All rights reserved.
//
import Foundation
import UIKit

protocol PhotoController: class {
    func showErrorAlert(_ error: NSError)
}

final class PhotosViewController: UIViewController {

    static let height: CGFloat = 100
    static let itemPerRow: CGFloat = 4

    fileprivate let photoInteractor: PhotoInteractor
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNibForSupplementaryViewOfKind(
            UICollectionElementKindSectionFooter, type: LoadingCollectionReusableView.self)
        collectionView.registerClassForSupplementaryViewOfKind(
            UICollectionElementKindSectionFooter, type: EmptyStateCollectionReusableView.self)
        collectionView.registerClassForCellWithType(PhotoCollectionViewCell.self)
        return collectionView
    }()

    init() {
        photoInteractor = PhotoInteractor()

        super.init(nibName: nil, bundle: nil)
        photoInteractor.controller = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addComponents()
        view.backgroundColor = UIColor.white

        setupNavigationItem()
        layoutComponents()

        setupLoadCompletion()
        fetchData()
    }

    private func setupNavigationItem() {
        navigationItem.title = "Recent Photos"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    private func fetchData() {
        photoInteractor.loadPhotos()
    }

    private func setupLoadCompletion() {
        photoInteractor.requestloadPhotosCompleteHandler = { [weak self] () in
            guard let localSelf = self else { return }
            localSelf.collectionView.reloadData()
        }
    }

    private func addComponents() {
        view.addSubview(collectionView)
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    fileprivate func scrollToBottom() -> Void {
        fetchData()
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {

        if photoInteractor.hasNextPage || photoInteractor.photosResponse == nil {
            return CGSize(width: collectionView.bounds.width, height: LoadingCollectionReusableView.Height)
        } else {
            if photoInteractor.numberOfItems == 0 {
                return CGSize(width: collectionView.bounds.width, height: 30)
            } else {
                return CGSize.zero
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / PhotosViewController.itemPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = photoInteractor.photosResponse?.values[indexPath.row] else { return }
        let vc = PhotoDetailViewController(for: photo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoInteractor.numberOfItems
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithType(
            PhotoCollectionViewCell.self, forIndexPath: indexPath)
        guard let photo = photoInteractor.photosResponse?.values[indexPath.row] else { fatalError() }
        cell.configure(for: photo)
        return cell
    }

    func collectionView(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath) -> UICollectionReusableView {

        if photoInteractor.hasNextPage || photoInteractor.photosResponse == nil {
            if photoInteractor.numberOfItems > 0 {
                scrollToBottom()
            }

            let view = collectionView.dequeueReusableSupplementaryViewWithType(
                LoadingCollectionReusableView.self, elementKind: kind, forIndexPath: indexPath)
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryViewWithType(
                EmptyStateCollectionReusableView.self, elementKind: kind, forIndexPath: indexPath)
            return view
        }
    }
}

extension PhotosViewController: PhotoController {
    func showErrorAlert(_ error: NSError) {
        let alertController = UIAlertController(title: "FLicker Error", message: error.domain, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
