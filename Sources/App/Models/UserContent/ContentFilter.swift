//
// Created by Alyx Mote on 8/5/22.
//

enum ContentFilter: String, Codable {
    case restricted = "restricted"
    case mature = "mature"
    case explicit = "explicit"
    case everything = "everything"
}