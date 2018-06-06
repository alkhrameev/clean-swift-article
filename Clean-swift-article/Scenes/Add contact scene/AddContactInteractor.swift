//
//  AddContactInteractor.swift
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

protocol AddContactBusinessLogic {
    func showContact(request: AddContact.ShowContact.Request)
    func saveContact(request: AddContact.Save.Request)
}

protocol AddContactDataStore {
    var contact: Contact? { get set }
}

final class AddContactInteractor: AddContactBusinessLogic, AddContactDataStore {
    var presenter: AddContactPresentationLogic?
    var worker = AddContactWorker()
    var contact: Contact?

    func showContact(request: AddContact.ShowContact.Request) {

        var currentContact: Contact

        if let contact = self.contact {
            currentContact = contact
        } else {
            currentContact = Contact()
            self.contact = currentContact
        }

        let response = AddContact.ShowContact.Response(contact: currentContact)

        presenter?.presentContact(response: response)
    }

    func saveContact(request: AddContact.Save.Request) {

        guard let firstName = request.firstNameText,
            !firstName.isEmpty,
            let lastName = request.lastNameText,
            !lastName.isEmpty,
            let phone = request.phoneText?.numericOnlyValue,
            phone.count == 11 else {

                let alertText = NSLocalizedString("You are missed one of required fileds: first name, last name or phone, phone should be with country code", comment: "")

                let response = AddContact.ShowMissingFields.Response(text: alertText)

                presenter?.presentMissingFileds(response: response)

                return
        }

        guard let contact = contact else {
            return
        }

        contact.firstName = firstName
        contact.lastName = lastName
        contact.address = request.adddress ?? ""
        contact.phone = phone

        worker.addOrUpdate(contact: contact)

        let response = AddContact.Save.Response()
        presenter?.presentSave(response: response)
    }
}
