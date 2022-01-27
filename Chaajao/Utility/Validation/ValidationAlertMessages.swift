//
//  validationAlertMessage.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 12/12/2021.
//

import Foundation

enum ValidationAlertMessages: String {
     case inValidEmail = "Invalid Email"
     case invalidFirstLetterCaps = "First Letter should be capital"
     case inValidPhone = "Invalid Phone"
     case invalidAlphabeticString = "Invalid String"
     case inValidPSW = "Invalid Password. Password must be alteast 6 characters long"
     case inValidFullname = "Invalid Fullname"
        
     case emptyPhone = "Phone cannot be empty"
     case emptyEmail = "Email cannot be empty"
     case emptyFirstLetterCaps = "Name cannot be empty"
     case emptyAlphabeticString = "Empty String"
     case emptyPSW = "Password cannot be empty"
     case emptyFullname = "Fullname cannot be empty"
    
     func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
     }
}
