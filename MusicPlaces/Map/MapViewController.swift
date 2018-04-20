//
//  MapViewController.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

protocol MapDisplayLogic: class {
    func addAnotationsToMap(_ viewModel: Map.SearchPlaces.ViewModel)
}

class MapViewController: UIViewController, MapDisplayLogic, KeyboardHandler {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuButton: UIView!
    @IBOutlet weak var searchRow: UIView!
    @IBOutlet weak var bottomRowConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuRow: UIView!
    @IBOutlet weak var tableView: UITableView!

    var interactor: MapBusinessLogic?
    var topContainerState: TopContainerState = .keyboardDisabled
    var menuContainerState: MenuContainerState = .hidden

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        addDismissHandler()
        setDelegateAndDataSource()
        setUI()
        addKeyboardHandler()
        registerNibs()
    }

    @IBAction func menuTapped(_ sender: UIButton) {
        changeMenuState()
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.bottomConstraint.constant = MapKeyboardInfo.constraintConstant(self.menuContainerState, top: self.topContainerState)
            self.view.layoutIfNeeded()
        })
    }

    func addAnotationsToMap(_ viewModel: Map.SearchPlaces.ViewModel) {
        DispatchQueue.main.async {
            if viewModel.shouldResetAnnotations {
                self.mapView.removeAllAnnotations()
            }
            self.mapView.addAnnotations(viewModel.annotations)
            self.tableView.reloadData()
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

    func didChangeKeyboardVisibility() {
        changeTopState()
    }

    func changeMenuState() {
        let isShown = (menuContainerState == .shown)
        menuContainerState = isShown ? .hidden : .shown
    }

    func changeTopState() {
        let isKeyboardEnabled = (topContainerState == .keyboardEnabled)
        topContainerState = isKeyboardEnabled ? .keyboardDisabled : .keyboardEnabled
    }
}

extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    var places: [Place] {
        return (mapView.annotations as? [Place] ?? [])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier) as? PlaceCell else {
            fatalError()
        }

        cell.setCell(places[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveMapToPlace(places[indexPath.row])
    }

    private func moveMapToPlace(_ place: Place) {
        DispatchQueue.main.async {
            let camera = MKMapCamera(lookingAtCenter: place.coordinate, fromDistance: 100000, pitch: 0, heading: 0)
            self.mapView.setCamera(camera, animated: true)
            self.mapView.selectAnnotation(place, animated: true)
        }
    }
}

extension MapViewController {
    private func setup() {
        let viewController = self
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        interactor.configureQueue()
    }

    func setUI() {
        searchRow.setCorner(radius: 24)
        menuButton.setCorner(radius: 24)
        menuRow.setCorner(radius: 14)
        tableView.setCorner(radius: 14)

        searchRow.setShadow(shadowRadius: 10, shadowOpacity: 0.4)
        menuRow.setShadow(shadowRadius: 10, shadowOpacity: 0.5)
    }

    func registerNibs() {
        mapView.register(PlaceMarker.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        tableView.register(PlaceCell.nib, forCellReuseIdentifier: PlaceCell.identifier)
    }

    func setDelegateAndDataSource() {
        inputTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        mapView.showsUserLocation = true
    }
}

extension MapViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView.removeAllAnnotations()
    }
}
