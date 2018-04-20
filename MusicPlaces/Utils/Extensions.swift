//
//  Extensions.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import UIKit

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

extension UIViewController {
    @objc func handleKeybaordNotification(notification: Notification) {
        guard let handler = self as? KeyboardHandler else { fatalError("PROTOCOL ERRROR") }
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }

        let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow

        handler.bottomConstraint.constant = isKeyboardShowing ? -keyboardFrame.height : 0

        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func addKeyboardHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybaordNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybaordNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

protocol KeyboardHandler {
    weak var bottomConstraint: NSLayoutConstraint! { get set }
}
