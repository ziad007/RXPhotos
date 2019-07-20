//
//  PhotosViewModel.swift
//  Photos
//
//  Created by ziad Bou Ismail on 1/11/19.
//  Copyright © 2019 ziad Bou Ismail. All rights reserved.
//

import Foundation

enum ViewState {
    case initilized
    case isLoading
    case isEmpty
    case isLoaded
    case error
}

struct PhotosViewModel {

    // MARK: - Input:
    var pagedPhotos: PagedPhotos?
    var error: Error?

    // MARK: - Output:
    var photos: [Photo] {
        return pagedPhotos?.values ?? []
    }
    var state: ViewState {
        if (hasNextPage || pagedPhotos == nil) && error == nil {
            return .isLoading
        } else if numberOfItems == 0 {
            return .isEmpty
        } else if pagedPhotos != nil && error == nil {
            return .isLoaded
        } else if error != nil {
            return .error
        } else {
            return .initilized
        }
    }

    var hasNextPage: Bool {
        return pagedPhotos?.hasNext ?? false
    }

    var numberOfItems: Int {
        return pagedPhotos?.values.count ?? 0
    }

    mutating func resetData() {
        pagedPhotos = nil
    }
}
