//
//  Extensions.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

extension UITextField {
    var textWithEmptyStringValidation: String {
        return self.text ?? ""
    }
}

extension UIView {
    func setShadow(offWidth: Double = 0, OffHeight: Double = 0, shadowRadius: CGFloat, shadowOpacity: Float, shouldRasterize: Bool = true) {
        self.layer.shadowColor = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: offWidth, height: OffHeight)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    func setCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

extension MapViewController {
    @objc func handleKeybaordNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        MapKeyboardInfo.keyboardHeight = keyboardFrame.height

        self.didChangeKeyboardVisibility()
        self.topRowConstraint.constant = MapKeyboardInfo.constraintConstant(self.menuContainerState, top: self.topContainerState)
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func addKeyboardHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybaordNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybaordNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

struct MapKeyboardInfo {
    static var keyboardHeight: CGFloat = 0

    static func constraintConstant(_ menu: MenuContainerState, top: TopContainerState) -> CGFloat {
        switch (menu, top) {
        case (.shown, .keyboardEnabled):
            return -(200 + MapKeyboardInfo.keyboardHeight)
        case (.shown, .keyboardDisabled):
            return -(200)
        case (.hidden, .keyboardEnabled):
            return -(MapKeyboardInfo.keyboardHeight)
        case (.hidden, .keyboardDisabled):
            return 0
        }
    }
}

enum TopContainerState {
    case keyboardEnabled
    case keyboardDisabled
}

enum MenuContainerState {
    case hidden
    case shown
}

extension MKMapView {
    func removeAllAnnotations() {
        self.removeAnnotations(self.annotations)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

