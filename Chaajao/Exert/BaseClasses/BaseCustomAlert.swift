//
//  BaseCustomAlert.swift
//  
//
//  Created by Ahmed Khan on 22/03/2020.
//  Copyright © 2020-21 TechSurge Inc. All rights reserved.
//

import UIKit

class BaseCustomAlert: BaseCustomController {
    
    @IBOutlet weak var backgroundView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView?.addTapGesture(tapNumber: 1, target: self, action: #selector(hideController))
    }

    @objc func hideController() {
        self.dismiss(animated: false, completion: nil)
    }

}
