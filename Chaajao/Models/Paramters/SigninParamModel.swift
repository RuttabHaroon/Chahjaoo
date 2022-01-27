//
//  SigninParamModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 11/12/2021.
//

import Foundation

import ObjectMapper

// MARK: - SignInParamModel
class SignInParamModel: Codable {
    var email, password, deviceToken, appVersion: String
    
}

