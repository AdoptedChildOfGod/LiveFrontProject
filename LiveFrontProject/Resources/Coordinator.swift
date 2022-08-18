//
//  Coordinator.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit

// MARK: - Protocols

protocol HasCoordinator: UIViewController {
    var coordinator: Coordinator? { get set }
}

class NavigationViewControllerWithCoordinator: UINavigationController, HasCoordinator {
    var coordinator: Coordinator?
}

class Coordinator {
    // MARK: - Properties

    var navigationController: UINavigationController

    // MARK: - Initial Views

    /// Initialize the coordinator
    /// - Parameter navigationController: A navigation controller that the coordinator will use for most of its operations
    init(createWith navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    /// Start the coordinator by going to the initial view
    func start(with initialVC: BaseViewController? = nil) {
        goTo(initialVC ?? MainViewController())
    }

    // MARK: - Navigating Back

    /// Go back to whatever the previous view on the stack is
    func goBack() {
        navigationController.popViewController(animated: true)
    }

    /// Go back to the initial view controller that the coordinator was started with
    func goBackToInitialViewController() {
        navigationController.popToRootViewController(animated: true)
    }

    // MARK: - Generics to Show Any View

    /// Show a view modally (ie, sliding up to cover the screen)
    /// - Parameters:
    ///   - viewToPresent: The view that you want to present, which has a coordinator object that you want to use
    ///   - presentingVC: The parent view (ie, self) from which to present the modal view
    ///   - extraSteps: A completion to handle any extra steps needed to initialize the new view (ie,  passing information, setting variables, etc)
    func showModally<T: BaseViewController>(_ viewToPresent: T, from presentingVC: UIViewController, extraSteps: (T) -> Void = { _ in }) {
        viewToPresent.coordinator = self
        viewToPresent.modalPresentationStyle = .overCurrentContext
        extraSteps(viewToPresent)
        presentingVC.present(viewToPresent, animated: true)
    }

    /// Transition to the next view sideways, as with a navigation controller
    /// - Parameters:
    ///   - viewToShow: The view that you want to transition to, which must have a coordinator object
    ///   - extraSteps: A completion to handle any extra steps needed to initialize the new view (ie,  passing information, setting variables, etc)
    func goTo<T: BaseViewController>(_ viewToShow: T, extraSteps: (T) -> Void = { _ in }) {
        viewToShow.coordinator = self
        extraSteps(viewToShow)
        navigationController.pushViewController(viewToShow, animated: true)
    }
}
