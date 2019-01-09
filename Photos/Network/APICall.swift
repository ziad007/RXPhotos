//
//  APICall.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/28/18.
//  Copyright © 2018 ziad Bou Ismail. All rights reserved.
//

import Foundation

let SharedAPICall = APICall()
typealias response = Result<Dictionary<String, Any>, NSError>

struct Keys {
    static let apiKey = "680165e3a460810ba433fb3ff7f5da26"
    static let apiSecret = "4ff5181d4ba70a17"
}
let apiBaseURL = "https://api.flickr.com/services/rest/"
let perPage = 40

protocol RequestApi {
    var method: String { get }
    var format: ResponseFormat { get }
    var akmethod: HTTPMethods { get }
    var page: Int { get }
    var queryString: String? { get }
}

enum ResponseFormat: String {
    case json = "json"
    case xml = "xml"
}

enum HTTPMethods {
    case get, post, put, patch, delete

        var description: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }

class APICall {

    func sendRequest<T: RequestApi>(
        _ API: T,
        handler: @escaping (response) -> Void)  {

        var urlEndpoint = apiBaseURL
        urlEndpoint.append(contentsOf: API.queryString ?? "")
        guard let url = URL(string: urlEndpoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.akmethod.description

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            if let error = error {
                DispatchQueue.main.async {
                    handler(Result.failure(error as NSError))
                }
                return
            }

            do {
                if let data = data,
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                    if let code = dictionary["code"] as? Int {

                        if let error = ErrorCodes(code: code)?.error {
                            handler(Result.failure(error as NSError))
                            return
                        }
                    }
                   DispatchQueue.main.async {
                        handler(Result.success(dictionary))
                    }
                }
            }
            catch let error as NSError {
                DispatchQueue.main.async {
                    handler(Result.failure(error as NSError))
                }
            }
        }
        task.resume()
    }
}
