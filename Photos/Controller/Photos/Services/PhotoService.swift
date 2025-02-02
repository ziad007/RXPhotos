
import Foundation
import RxSwift

typealias PhotoResponse = (Result<PagedPhotos?, NSError>) -> Void

protocol PhotoServiceProtocol {

    func getRecentPhotos(page: Int) -> Observable<Result<PagedPhotos?, NSError>>
    func fetchNextRecentPhotos(previousPhotos: PagedPhotos) -> Observable<Result<PagedPhotos?, NSError>>
}

final class PhotoService: PhotoServiceProtocol {

    let apiCall: APICall
    private let disposeBag = DisposeBag()

    init(apiCall: APICall = APICall()) {
        self.apiCall = apiCall
    }

    func getRecentPhotos(page: Int = 1) -> Observable<Result<PagedPhotos?, NSError>> {
        return Observable.create { observer in
            let api = PhotosApi.GetRecent(page: page)
            self.apiCall.sendRequest(api) { response in
                switch(response) {
                case .success(let result):
                    guard let photosContainer = result["photos"] as? NSDictionary else { return }
                    let pagedPhotos = PagedPhotos(json: photosContainer)
                    observer.on(.next(.success(pagedPhotos)))
                    observer.on(.completed)
                case .failure(let error):
                    observer.on(.next(.failure(error as NSError)))
                    observer.on(.completed)
                }
            }
            return Disposables.create()
        }
    }

    func fetchNextRecentPhotos(previousPhotos: PagedPhotos) -> Observable<Result<PagedPhotos?, NSError>>  {
        return Observable.create { observer in
            self.getRecentPhotos(page: previousPhotos.nextPage)
                .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    if var response = response {
                        var mutablePhotos = previousPhotos.values
                        mutablePhotos.append(contentsOf: response.values)
                        response.values = mutablePhotos
                        observer.on(.next(.success(response)))
                        observer.on(.completed)
                    }
                case .failure(let error):
                    observer.on(.next(.failure(error as NSError)))
                    observer.on(.completed)
                }
            })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}




