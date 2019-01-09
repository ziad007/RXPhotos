//
//  Photos.swift
//  PhotoViewer
//
//  Created by ziad Bou Ismail on 9/17/17.
//  Copyright © 2017 ziad Bou Ismail. All rights reserved.
//

import Foundation

struct Photo {

    let id: String
    let owner: String?
    let farm: Int
    let title: String?
    let secret: String
    let server: String

    var photoUrl: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_s.jpg")
    }
    var largePhotoUrl: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg")
    }
}

extension Photo {
    init?(json: NSDictionary) {
        guard let id = json["id"] as? String,
                let title = json["title"] as? String,
                let farm = json["farm"] as? Int,
                let owner = json["owner"] as? String,
                let secret = json["secret"] as? String,
                let server = json["server"] as? String
            else {
                    return nil
            }

        self.id = id
        self.owner = owner
        self.farm = farm
        self.title = title
        self.secret = secret
        self.server = server
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        guard let lhsID = Int(lhs.id) , let rhsID = Int(rhs.id) else { return false }
        return lhsID == rhsID
    }
}
