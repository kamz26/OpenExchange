//
//  UIKIT+Extension.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 09/08/22.
//

import Foundation
import UIKit

//MARK:- UITableView
extension UITableView {
     func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
 
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func reloadAsync() {
        DispatchQueue.main.async {
             self.reloadData()
        }
    }
}

//MARK: - UIcollectionView
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func reloadAsync() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

//MARK: - UIView
extension UIView{
  func addBorder(with width:CGFloat, borderColor:UIColor, cornerRadius:CGFloat){
    self.layer.borderWidth = width
    self.layer.borderColor = borderColor.cgColor
    self.layer.cornerRadius = cornerRadius
  }
}


extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(cancelsTouchesInView: Bool? = nil,  action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        
        if cancelsTouchesInView != nil  {
            tapGestureRecognizer.cancelsTouchesInView = cancelsTouchesInView!
        }
        
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public func removeTapGesture(){
        self.isUserInteractionEnabled = false
        self.gestureRecognizers?.removeAll()
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}
