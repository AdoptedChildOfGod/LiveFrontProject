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
        goTo(initialVC ?? SplashViewController())
    }

    /// Go to the home page of the app (the first view after auth is completed)
    func goToHomeView() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.coordinator = self

//        let mainTabVC = MainTabViewController()
//        mainTabVC.coordinator = self

        navigationController.setNavigationBarHidden(true, animated: false)
//        navigationController.setViewControllers([welcomeVC, mainTabVC], animated: true)
        navigationController.setViewControllers([welcomeVC], animated: true)
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

    /// Show a view modally (ie, sliding up to cover the screen)
    /// - Parameters:
    ///   - viewToPresent: The view that you want to present
    ///   - presentingVC: The parent view (ie self) from which to present the modal view
    ///   - extraSteps: A completion to handle any extra steps needed to initialize the new view (ie,  passing information, setting variables, etc)
    func showModally<T: UIViewController>(_ viewToPresent: T, from presentingVC: UIViewController, extraSteps: (T) -> Void = { _ in }) {
        viewToPresent.modalPresentationStyle = .overCurrentContext
        extraSteps(viewToPresent)
        presentingVC.present(viewToPresent, animated: true)
    }

    /// Show a view modally (ie, sliding up to cover the screen) but embed it in a navigation view so as to show the navigation bar at the top
    /// - Parameters:
    ///   - viewToPresent: The view that you want to present
    ///   - presentingVC: The parent view (ie self) from which to present the modal view
    ///   - extraSteps: A completion to handle any extra steps needed to initialize the new view (ie,  passing information, setting variables, etc)
    func showModallyWithNavBar<T: HasCoordinator>(_ viewToPresent: T, from presentingVC: UIViewController?, extraSteps: (T) -> Void = { _ in }) {
        guard let presentingVC = presentingVC else { return }

        // Set up the container navigation controller
        let containerNavController = BaseNavigationController()
        containerNavController.coordinator = Coordinator(createWith: containerNavController)
        containerNavController.modalPresentationStyle = .overFullScreen
        containerNavController.pushViewController(viewToPresent, animated: false)

        // Set up the main view
        extraSteps(viewToPresent)
        viewToPresent.coordinator = containerNavController.coordinator

        // Show the view in its container navigation controller
        presentingVC.present(containerNavController, animated: true)
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
