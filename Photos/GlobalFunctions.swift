import Foundation
import UIKit

func ClassNameFromClass(_ aClass: AnyClass) -> String {
    return String(describing: aClass)
}

func ClassNameFromObject(_ object: AnyObject) -> String {
    return ClassNameFromClass(type(of: object))
}
