//
//  ContactListRouter.swift
//  Clean-swift-article
//
//  Created by Anton Marunko on 25/05/2018.
//  Copyright (c) 2018 exyte. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ContactListRoutingLogic {
    func routeToViewContact(segue: UIStoryboardSegue?)
    func routeToAddContact(segue: UIStoryboardSegue?)
}

protocol ContactListDataPassing {
    var dataStore: ContactListDataStore? { get }
}

final class ContactListRouter: NSObject, ContactListRoutingLogic, ContactListDataPassing {
    weak var viewController: ContactListViewController?
    var dataStore: ContactListDataStore?

    // MARK: Routing

    func routeToViewContact(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! ContactViewViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToViewContact(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Contact", bundle: .none)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "contactViewControl") as! ContactViewViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToViewContact(source: dataStore!, destination: &destinationDS)
            navigateToViewContact(source: viewController!, destination: destinationVC)
        }
    }

    func routeToAddContact(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! AddContactViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToAddContact(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Contact", bundle: .none)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "addContactControl") as! AddContactViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToAddContact(source: dataStore!, destination: &destinationDS)
            navigateToAddContact(source: viewController!, destination: destinationVC)
        }
    }

    // MARK: - Navigation

    func navigateToAddContact(source: ContactListViewController, destination: AddContactViewController) {
        source.show(destination, sender: .none)
    }

    func navigateToViewContact(source: ContactListViewController, destination: ContactViewViewController) {
        source.show(destination, sender: .none)
    }

    // MARK: - Passing data

    func passDataToAddContact(source: ContactListDataStore, destination: inout AddContactDataStore) {
    }

    func passDataToViewContact(source: ContactListDataStore, destination: inout ContactViewDataStore) {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination.contact = source.contacts?[selectedRow!]
    }
}
