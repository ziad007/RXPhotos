//
//  PhotosApi.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/29/18.
//  Copyright © 2018 ziad Bou Ismail. All rights reserved.
//

import Foundation

final class PhotosApi {
    struct GetRecent: RequestApi  {
        let method = "flickr.photos.getRecent"
        let format: ResponseFormat = .json
        let akmethod: HTTPMethods = .get
        let page: Int
        var queryString: String? {
            return "?method=\(method)&format=\(format.rawValue)&nojsoncallback=1&api_key=\(Keys.apiKey)&per_page=\(perPage)&page=\(page)"
        }
    }
}
