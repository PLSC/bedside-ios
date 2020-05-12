//
//  FoundationExtensions.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation

extension String {
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
