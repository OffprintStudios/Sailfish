//
// Created by Alyx Mote on 7/30/22.
//

import Foundation

func canAccess(needs requiredRoles: [Account.Roles], has rolesPresent: [Account.Roles]) -> Bool {
    let requiredSet = Set(requiredRoles)
    let presentSet = Set(rolesPresent)

    return requiredSet.intersection(presentSet).count != 0
}