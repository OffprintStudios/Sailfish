//
// Created by Alyx Mote on 7/30/22.
//

import Foundation

func canAccess(needs requiredRoles: Set<Account.Roles>, has rolesPresent: Set<Account.Roles>) -> Bool {
    requiredRoles.intersection(rolesPresent).count != 0
}