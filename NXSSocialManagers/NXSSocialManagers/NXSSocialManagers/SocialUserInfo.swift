//
//  SocialUserInfo.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 01/02/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit

enum SocialLoginType: Int {
    case facebook = 1
    case google = 2
    case instagram = 3
    case apple = 4
}

struct SocialUserInfo {
    var type: SocialLoginType = .facebook
    var userId: String = ""
    var name: String = ""
    var email: String = ""
    var profilePic: String = ""

    var firstName: String {
        return Name(fullName: self.name).first
    }

    var lastName: String {
        return Name(fullName: self.name).last
    }
}

struct Name {
    let first: String
    let last: String

    init(first: String, last: String) {
        self.first = first
        self.last = last
    }
}

extension Name {
    init(fullName: String) {
        var names = fullName.components(separatedBy: " ")
        let first = names.removeFirst()
        let last = names.joined(separator: " ")
        self.init(first: first, last: last)
    }
}

extension Name: CustomStringConvertible {
    var description: String { return "\(first) \(last)" }
}
