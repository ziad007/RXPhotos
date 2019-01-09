//
//  PhotosTests.swift
//  PhotosTests
//
//  Created by ziad Bou Ismail on 9/17/17.
//  Copyright © 2017 ziad Bou Ismail. All rights reserved.
//

import XCTest
@testable import Photos

class PhotoInteractorTest: XCTestCase {

    var photosResponse: PagedPhotos?

    class MockService: PhotoServiceProtocol {
        func getRecentPhotos(page: Int, completionHandler: @escaping PhotoResponse) {
            let photos = PagedPhotos(json: ["page": 1, "pages": 25, "perpage":40, "total": 1000, "photo": [["id":"30080124297", "title": "Fall", "farm": 2, "owner": "44124378412", "secret": "354443384b", "server": "1944"]]])
                completionHandler(Result.success(photos))
        }

        func fetchNextRecentPhotos(pagedPhotos: PagedPhotos, completionHandler: @escaping PhotoResponse) {
            let photos = PagedPhotos(json: ["page": 2, "pages": 25, "perpage":40, "total": 1000, "photo": [["id":"300801242971", "title": "Fall", "farm": 2, "owner": "44124378412", "secret": "354443384b", "server": "1944"]]])
            completionHandler(Result.success(photos))

        }
    }

    var interactor: PhotoInteractor!
    var photoResponse: PagedPhotos?

    override func setUp() {

        interactor = PhotoInteractor()
        interactor.photoService = MockService()
        super.setUp()
    }

    func testViewDidLoad() {
        var scrolled = false
        interactor.requestloadPhotosCompleteHandler = { _ in
            if !scrolled {
                XCTAssertEqual(self.interactor.photosResponse?.values.count, 1)
                XCTAssertEqual(self.interactor.photosResponse?.hasNext, true)
            } else {
                 XCTAssertEqual(self.interactor.photosResponse?.values.count, 2)
            }

        }
        
        interactor.loadPhotos()
        scrolled = true
        interactor.loadPhotos()
    }
}
