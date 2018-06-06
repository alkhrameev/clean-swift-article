//
//  ContactViewViewController.swift
//  Clean-swift-article
//
//  Created by Anton Marunko on 30/05/2018.
//  Copyright (c) 2018 exyte. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ContactViewDisplayLogic: class {
    func displayContact(viewModel: ContactView.ShowContact.ViewModel)
}

final class ContactViewViewController: UIViewController, ContactViewDisplayLogic {
    var interactor: ContactViewBusinessLogic?
    var router: (NSObjectProtocol & ContactViewRoutingLogic & ContactViewDataPassing)?

    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = ContactViewInteractor()
        let presenter = ContactViewPresenter()
        let router = ContactViewRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    // MARK: - Interactor requests

    func fetchData() {
        let request = ContactView.ShowContact.Request()
        interactor?.fetchContact(request: request)
    }

    // MARK: - ContactViewDisplayLogic

    func displayContact(viewModel: ContactView.ShowContact.ViewModel) {
        firstNameLabel.text = viewModel.firstName
        lastNameLabel.text = viewModel.lastName
        addressLabel.text = viewModel.address
        phoneLabel.text = viewModel.phone
    }
}
