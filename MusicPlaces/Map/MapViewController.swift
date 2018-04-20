//
//  MapViewController.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import UIKit
import MapKit

protocol MapDisplayLogic: class {
    func addAnotationsToMap(_ viewModel: Map.SearchPlaces.ViewModel)
}

enum TopContainerState {
    case keyboardEnabled
    case keyboardDisabled
}

enum MenuContainerState {
    case hidden
    case shown
}

func constraintConstant(_ menu: MenuContainerState, top: TopContainerState) {
    switch (menu, top) {
    case (.shown, .keyboardEnabled): break
        // INITIAL + KEYBOARD HEIGHT + MENU CONTAINER
    case (.shown, .keyboardDisabled): break
        // INITIAL + MENU CONTAINER
    case (.hidden, .keyboardEnabled):break
        // INITIAL + KEYBOARD HEIGHT
    case (.hidden, .keyboardDisabled):break
    }   // INITIAL
}

class MapViewController: UIViewController, MapDisplayLogic, KeyboardHandler {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuButton: UIView!
    @IBOutlet weak var searchRow: UIView!

    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissHandler()
        mapView.register(PlaceMarker.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        addTextFieldDelegate()
        setUI()
        addKeyboardHandler()
    }

    @IBAction func menuTapped(_ sender: UIButton) {
        // TODO
    }

    func addAnotationsToMap(_ viewModel: Map.SearchPlaces.ViewModel) {
        DispatchQueue.main.async {
            if viewModel.shouldResetAnnotations {
                self.mapView.removeAllAnnotations()
            }
            self.mapView.addAnnotations(viewModel.annotations)
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension MapViewController: UITextFieldDelegate {
    func addTextFieldDelegate() {
        self.inputTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        downloadLocations()
        dismissKeyboard()
        return true
    }
}

extension MapViewController {
    fileprivate func downloadLocations() {
        let request = Map.SearchPlaces.Request(searchPhrase: inputTextField.textWithEmptyStringValidation)
        interactor?.searchPlaces(request)
    }
}

extension MapViewController {
    func addDismissHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer? = nil) {
        self.inputTextField.resignFirstResponder()
    }

    func setUI() {
        searchRow.setCorner(radius: 24)
        menuButton.setCorner(radius: 24)

        searchRow.setShadow(shadowRadius: 10, shadowOpacity: 0.4)
    }
}

extension MapViewController {
    private func setup() {
        let viewController = self
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        let router = MapRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        interactor.configureQueue()
    }
}

extension MapViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView.removeAllAnnotations()
    }
}
