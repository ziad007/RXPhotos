
import Foundation

 struct PagedPhotos {

    var perPage: Int?
    var page = 1
    var pages: Int?
    var total: Int?
    var values = [Photo]()

    var hasNext: Bool? {
        return page < (pages ?? 1)
    }

    var nextPage: Int {
        return page + 1
    }

    init() {}

    init?(json: NSDictionary) {
        guard let perPage = json["perpage"] as? Int,
            let page = json["page"] as? Int,
            let total = json["total"] as? Int,
            let pages = json["pages"] as? Int,
            let values = json["photo"] as? [NSDictionary]
            else {
                return nil
        }

        self.perPage = perPage
        self.pages = pages
        self.page = page
        self.total = total

        self.values = values.compactMap { photoDictionary in
            guard let photo = Photo(json: photoDictionary) else { return nil }
            return photo
        }
    }
}
