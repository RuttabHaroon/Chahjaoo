//
//  ValidationEnums.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 12/12/2021.
//

import Foundation

enum Alert {        //for failure and success results
    case success
    case failure
    case error
}
//for success or failure of validation with alert message
enum Valid {
    case success
    case failure(Alert, ValidationAlertMessages)
}
enum ValidationType {
    case fullname
    case email
    case stringWithFirstLetterCaps
    case phoneNo
    case alphabeticString
    case password
}
enum RegEx: String {
    case fullname = "^.{3,50}$" //Full name
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{5,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{10,14}" // PhoneNo 10-14 Digits        //Change RegEx according to your Requirement
}
