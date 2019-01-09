import Foundation
import UIKit
// Register a nib file where its owner class has same name as the nib file
// and set the class name as an identifer
extension UICollectionView {
    func registerNibForCellWithType<T: UICollectionViewCell>(_ type: T.Type) {
        let className = ClassNameFromClass(type)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    func registerNibForSupplementaryViewOfKind<T: UICollectionReusableView>(_ kind: String, type: T.Type) {
        let className = ClassNameFromClass(type)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: className)
    }
}

// Register a class with its name as an identifer
extension UICollectionView {
    func registerClassForCellWithType<T: UICollectionViewCell>(_ type: T.Type) {
        let className = ClassNameFromClass(type)
        register(type, forCellWithReuseIdentifier: className)
    }
    func registerClassForSupplementaryViewOfKind<T: UICollectionReusableView>(_ kind: String, type: T.Type) {
        let className = ClassNameFromClass(type)
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
}

// Deque by class (class name)
extension UICollectionView {
    func dequeueReusableCellWithType<T: UICollectionViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: ClassNameFromClass(type), for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    func dequeueReusableSupplementaryViewWithType<T: UICollectionReusableView>(_ type: T.Type, elementKind: String, forIndexPath indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: ClassNameFromClass(type), for: indexPath) as? T else {
            fatalError()
        }
        return view
    }
}
