//
//  ErrorCodes.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/23/17.
//  Copyright © 2017 ziad Bou Ismail. All rights reserved.
//

import Foundation


enum ErrorCodes: Int {
    case InvalidAPIKey = 100
    case ServiceCurrentlyUnavailable = 105
    case WriteOperationFailed = 106
    case FormatNotFound = 111
    case InvalidSOAPEnvelope = 112
    case InvalidXMLRPCMethodCall = 114

    init?(code: Int) {
        self.init(rawValue: code)
    }

    var description: String {
        switch self {

        case .InvalidAPIKey:
            return "The API key passed was not valid or has expired."
        case .ServiceCurrentlyUnavailable:
            return "The requested service is temporarily unavailable."
        case .WriteOperationFailed:
            return "The requested operation failed due to a temporary issue."
        case .FormatNotFound:
            return "The requested method was not found."
        case .InvalidSOAPEnvelope:
            return "The SOAP envelope send in the request could not be parsed."
        case .InvalidXMLRPCMethodCall:
            return "The XML-RPC request document could not be parsed."
        }
    }

    var error: NSError {
        return NSError(domain: description, code: self.rawValue, userInfo: nil)
    }
}
