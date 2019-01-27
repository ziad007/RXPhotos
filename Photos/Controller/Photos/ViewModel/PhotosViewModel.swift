//
//  PhotosViewModel.swift
//  Photos
//
//  Created by ziad Bou Ismail on 1/11/19.
//  Copyright © 2019 ziad Bou Ismail. All rights reserved.
//

import Foundation

struct PhotosViewModel {

    var photosResponse: PagedPhotos?

    var error: Error?

    var photos: [Photo] {
        return photosResponse?.values ?? []
    }

    var isLoading: Bool {
        return (hasNextPage || photosResponse == nil) && error == nil
    }

    var isEmpty: Bool {
        return numberOfItems == 0
    }

    var hasNextPage: Bool {
        return photosResponse?.hasNext ?? false
    }

    var numberOfItems: Int {
        return photosResponse?.values.count ?? 0
    }
}
