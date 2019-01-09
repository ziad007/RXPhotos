
import Foundation

typealias PhotoResponse = (Result<PagedPhotos?, NSError>) -> Void

protocol PhotoServiceProtocol {
    func getRecentPhotos(page: Int, completionHandler: @escaping PhotoResponse)
    func fetchNextRecentPhotos(pagedPhotos: PagedPhotos, completionHandler: @escaping PhotoResponse)
}

final class PhotoService: PhotoServiceProtocol {

    let apiCall: APICall

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

    func getRecentPhotos(page: Int = 1, completionHandler: @escaping PhotoResponse) {
        let api = PhotosApi.GetRecent(page: page)
        self.apiCall.sendRequest(api) { response in
            switch(response) {
            case .success(let result):
                guard let photosContainer = result["photos"] as? NSDictionary else { return }

                let pagedPhotos = PagedPhotos(json: photosContainer)
                completionHandler(Result.success(pagedPhotos))
            case .failure(let error):
                  completionHandler(Result.failure(error as NSError))
            }
        }
    }

    func fetchNextRecentPhotos(pagedPhotos: PagedPhotos, completionHandler: @escaping PhotoResponse) {
            getRecentPhotos(page: pagedPhotos.nextPage) {
                response in
                switch(response) {
                case .success(let response):
                    if let response = response {
                        completionHandler(Result.success(response))
                    }
                case .failure(let error):
                    completionHandler(Result.failure(error as NSError))
                }
            }
    }
}
