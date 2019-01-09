//
//  PhotoInteractor.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/30/18.
//  Copyright © 2018 ziad Bou Ismail. All rights reserved.
//

import Foundation

protocol PhotoInteractorInputs {
    func loadPhotos()
}

protocol PhotoInteractorOutputs {
    var photosResponse: PagedPhotos? { get }
}

final class PhotoInteractor: PhotoInteractorInputs, PhotoInteractorOutputs {
    var photoService: PhotoServiceProtocol
    weak var controller: PhotosViewController?
    var photosResponse: PagedPhotos?
    var requestloadPhotosCompleteHandler: (() -> Void)?

    var hasNextPage: Bool {
        return photosResponse?.hasNext ?? false
    }

    var numberOfItems: Int {
        return photosResponse?.values.count ?? 0
    }

    init() {
        photoService = PhotoService()
    }

    func loadPhotos() {
        if let previousResult = photosResponse {
            photoService.fetchNextRecentPhotos(pagedPhotos: previousResult) { [weak self] (response) in
                guard let localSelf = self else { return }
                switch response {
                case .success(let response):
                    if let response = response {
                        localSelf.photosResponse = localSelf.appendData(for: previousResult, nextPhotosReponse: response)
                        localSelf.requestloadPhotosCompleteHandler?()
                    }
                case .failure(let error):
                    localSelf.controller?.showErrorAlert(error)
                }
            }
        } else {
            photoService.getRecentPhotos(page: 1) { [weak self] (response) in
                guard let localSelf = self else { return }

                switch response {
                case .success(let response):
                    localSelf.photosResponse = response
                    localSelf.requestloadPhotosCompleteHandler?()
                case .failure(let error):
                    localSelf.controller?.showErrorAlert(error)
                }
            }
        }
    }

    private func appendData(for previousPhotosResponse: PagedPhotos, nextPhotosReponse: PagedPhotos) -> PagedPhotos {
        var newPhotosReponse = nextPhotosReponse
        var photos = previousPhotosResponse.values
        photos.append(contentsOf: nextPhotosReponse.values)
        newPhotosReponse.values = photos
        return newPhotosReponse
    }
}
