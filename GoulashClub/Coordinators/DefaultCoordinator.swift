//
//  MainCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 05/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

protocol DefaultCoordinatorDelegate: class {
    @available(iOS 13.0, *)
    func requestSceneForPlace(with placeId: String, from coordinator: DefaultCoordinator)
}

class DefaultCoordinator: NSObject, Coordinating, Restorable {
    let identifier = UUID().uuidString
    let splitViewController = GoulashSplitViewController()
    weak var delegate: DefaultCoordinatorDelegate?
    
    let window: UIWindow
    let dependencies: AppDependencable
    
    private(set) var childCoordinators: [Coordinating] = []
    private(set) var restorationActivity: DefaultSceneActivity?
    
    // Bool indicating that split view is expanding
    private var isExpanding = false
    
    // Id of a place that should be shown to restore activity
    private var placeIdToShow: String?
    private lazy var masterCoordinator: ListCoordinator = {
        ListCoordinator(dependencies: self.dependencies, delegate: self)
    }()

    init(dependencies: AppDependencable, window: UIWindow) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() {
        dependencies.databaseManager.register(placesListener: self)
        
        childCoordinators.append(masterCoordinator)
        masterCoordinator.start()
        splitViewController.viewControllers = [masterCoordinator.rootViewController]
        masterCoordinator.rootViewController.delegate = self
        splitViewController.delegate = self
        
        restorationActivity = DefaultSceneActivity()
        
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
    }
    
    func showDetail(for placeId: String) {
        if case .ready(let places) = dependencies.databaseManager.places, let place = places.first(where: { $0.id == placeId }) {
            presentDetail(for: place)
        } else {
            placeIdToShow = placeId
        }
    }
}

// MARK: Places listener
extension DefaultCoordinator: PlacesDatabaseListener {
    func didUpdatePlaces(_ places: DataStatus<[Place]>) {
        // Only if no detail is presented
        guard case .ready(let places) = places, splitViewController.viewControllers.count == 1 else {
            return
        }
        
        // If there is a place that should be shown to restore an activity do so
        // Else if app receives data for the first time and horizontal size class is regular present detail of the first place
        if let id = placeIdToShow, let place = places.first(where: { $0.id == id }) {
            placeIdToShow = nil
            presentDetail(for: place)
        } else if splitViewController.traitCollection.horizontalSizeClass == .regular,
            let place = places.first {
                presentDetail(for: place)
        }
    }
}

// MARK: Actions
extension DefaultCoordinator {
    func didSelect(place: Place, in controller: PlacesViewController) {
        presentDetail(for: place)
    }
}

// MARK: List coordinator delegate
extension DefaultCoordinator: ListCoordinatorDelegate {
    func presentDetail(for place: Place) {
        let options = shouldShowDetail(for: place)
        if options.pop {
            masterCoordinator.rootViewController.popToRootViewController(animated: false)
        }
        if options.show {
            showDetail(for: place)
        }
    }
    
    private func shouldShowDetail(for place: Place) -> (show: Bool, pop: Bool) {
        let coodinator = childCoordinators.compactMap({ $0 as? DetailCoordinator }).first
        
        guard coodinator?.placeId != place.id else {
            return (false, false)
        }
        
        if masterCoordinator.rootViewController.viewControllers.count == 1 {
            return (true, false)
        } else if masterCoordinator.rootViewController.viewControllers.count > 1 {
            return (true, true)
        }
        
        return (false, false)
    }
    
    private func showDetail(for place: Place) {
        childCoordinators = childCoordinators.filter({ $0.identifier == self.masterCoordinator.identifier })
        
        let detailCoordinator = createDetail(for: place.id)

        splitViewController.showDetailViewController(detailCoordinator.rootViewController, sender: masterCoordinator.rootViewController)
    }
    
    private func createDetail(for placeId: String) -> DetailCoordinator {
        let detailCoordinator = DetailCoordinator(dependencies: dependencies, placeId: placeId)
        detailCoordinator.delegateInSplitView = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
        
        restorationActivity?.didOpenDetail(for: placeId)

        return detailCoordinator
    }
}

// MARK: Detail coordinator delegate
extension DefaultCoordinator: DetailCoordinatorInSplitDelegate {
    @available(iOS 13.0, *)
    func requestSceneForPlace(with placeId: String) {
        delegate?.requestSceneForPlace(with: placeId, from: self)
    }
}

extension DefaultCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard primaryViewController == masterCoordinator.rootViewController else {
            return nil
        }
        
        if masterCoordinator.rootViewController.viewControllers.count > 1 {
            isExpanding = true
        } else if case .ready(let places) = dependencies.databaseManager.places, let place = places.first {
            let coordinator = createDetail(for: place.id)
            return coordinator.rootViewController
        }
        
        return nil
    }
}

// MARK: Split view controller delegate
extension DefaultCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard !isExpanding else {
            isExpanding = false
            return
        }
        
        if navigationController.viewControllers.count == 1 {
            restorationActivity?.didCloseDetail()
            childCoordinators = childCoordinators.filter({ $0.identifier == self.masterCoordinator.identifier })
        }
    }
}
