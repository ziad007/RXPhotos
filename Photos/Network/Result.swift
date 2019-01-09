//
//  Result.swift
//  Photos
//
//  Created by ziad Bou Ismail on 9/23/17.
//  Copyright © 2017 ziad Bou Ismail. All rights reserved.
//

import Foundation

public enum Result<T, Error: NSError> {
    case success(T)
    case failure(NSError)
}
