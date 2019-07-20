//
//  PhotoInteractor.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/30/18.
//  Copyright © 2018 ziad Bou Ismail. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotoInteractorOutputs {
    var photosViewModel: Observable<PhotosViewModel> { get }
}

final class PhotoInteractor: PhotoInteractorOutputs {
    var photoService: PhotoServiceProtocol
    weak var controller: PhotosViewController?

    private let photosViewModelVariable: Variable<PhotosViewModel>
    var photosViewModel: Observable<PhotosViewModel>
    private let disposeBag = DisposeBag()

    init() {
        photoService = PhotoService()
        let photoViewModelInitilized = PhotosViewModel()
        photosViewModelVariable = Variable(photoViewModelInitilized)
        photosViewModel = photosViewModelVariable.asObservable()
    }

    func resetData() {
        photosViewModelVariable.value.resetData()
        loadPhotos()
    }

    func loadPhotos() {
        if let previousPagedPhotos = photosViewModelVariable.value.pagedPhotos {
            photoService.fetchNextRecentPhotos(previousPhotos: previousPagedPhotos)
                .subscribe(onNext: { [weak self] result in
                    guard let localSelf = self else { return }
                    switch result {
                    case .success(let response):
                        if let response = response {
                            localSelf.photosViewModelVariable.value.pagedPhotos = response
                        }
                    case .failure(let error):
                        localSelf.controller?.showErrorAlert(error)
                        localSelf.photosViewModelVariable.value.error = error

                    }
                })
                .disposed(by: disposeBag)
        } else {
            photoService.getRecentPhotos(page: 1)
                .subscribe(onNext: { [weak self] result in
                    guard let localSelf = self else { return }
                    switch result {
                    case .success(let response):
                        localSelf.photosViewModelVariable.value.pagedPhotos = response
                    case .failure(let error):
                        localSelf.controller?.showErrorAlert(error)
                        localSelf.photosViewModelVariable.value.error = error

                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
