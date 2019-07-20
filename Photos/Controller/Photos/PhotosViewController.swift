//
//  ViewController.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/17/17.
//  Copyright © 2017 ziad Bou Ismail. All rights reserved.
//
import Foundation
import UIKit
import RxSwift

protocol PhotoController: class {
    func showErrorAlert(_ error: NSError)
}

final class PhotosViewController: UIViewController {

    static let height: CGFloat = 100
    static let itemPerRow: CGFloat = 4

    private let photoInteractor: PhotoInteractor
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private var photosViewModel: PhotosViewModel?

    private let disposeBag = DisposeBag()
    var refreshControl: UIRefreshControl!


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
            UICollectionView.elementKindSectionFooter, type: LoadingCollectionReusableView.self)
        collectionView.registerClassForSupplementaryViewOfKind(
            UICollectionView.elementKindSectionFooter, type: EmptyStateCollectionReusableView.self)
        collectionView.registerClassForCellWithType(PhotoCollectionViewCell.self)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)

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

        bindViewModel()
        fetchData()
    }

    private func setupNavigationItem() {
        navigationItem.title = "Recent Photos"
    }

    private func fetchData() {
        photoInteractor.loadPhotos()
    }

    

    private func bindViewModel() {

        photoInteractor.photosViewModel
            .subscribe(onNext: { [weak self] photoViewModel in
                guard let localSelf = self else { return }
                localSelf.photosViewModel = photoViewModel
                localSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

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

    private func didScrollToBottom() -> Void {
        fetchData()
    }

    @objc func didPullToRefresh() {
        photoInteractor.resetData()

        refreshControl.endRefreshing()
    }
    
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {

        guard let photosViewModel = photosViewModel else { fatalError() }

        switch photosViewModel.state {
        case .isLoading:
            return CGSize(width: collectionView.bounds.width, height: LoadingCollectionReusableView.Height)
        case .isEmpty:
            return CGSize(width: collectionView.bounds.width, height: 30)
        default:
            return CGSize.zero
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
        guard let photosViewModel = photosViewModel else { fatalError() }

        let photo = photosViewModel.photos[indexPath.row]
        let vc = PhotoDetailViewController(for: photo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosViewModel?.numberOfItems ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let photosViewModel = photosViewModel else { fatalError() }

        let cell = collectionView.dequeueReusableCellWithType(
            PhotoCollectionViewCell.self, forIndexPath: indexPath)
        let photo = photosViewModel.photos[indexPath.row]
        cell.configure(for: photo)
        return cell
    }

    func collectionView(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath) -> UICollectionReusableView {

        guard let photosViewModel = photosViewModel else { fatalError() }

        if photosViewModel.state == .isLoading {
            if photosViewModel.hasNextPage {
                didScrollToBottom()
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
