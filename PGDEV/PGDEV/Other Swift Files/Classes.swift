//
//  Classes.swift
//  PGDEV
//
//  Created by Family on 9/29/24.
//

import Foundation

class Reporter: Codable {
    var name = "Unset"
    var valid = false
    
    init(name: String, valid: Bool) {
        self.name = name
        self.valid = valid
    }
}

extension Reporter: Equatable {
    static func == (lhs: Reporter, rhs: Reporter) -> Bool {
        return lhs.name == rhs.name && lhs.valid == rhs.valid
    }
}

class Player: Codable {
    var pName = "Unset"
    var reps = 0
    var repts: [Reporter] = []
    var defState = "None"
    var state = "None"
    
    init(pName: String, reps: Int, repts: [Reporter], defState: String, state: String) {
        self.pName = pName
        self.reps = reps
        self.repts = repts
        self.defState = defState
        self.state = state
    }
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.pName == rhs.pName && lhs.reps == rhs.reps && lhs.repts == rhs.repts && lhs.defState == rhs.defState && lhs.state == rhs.state
    }
}

struct RepAPI: Codable {
    let record: [Record?]
    let metadata: Metadata
}

struct Metadata: Codable {
    let id: String
    let metadataPrivate: Bool
    let createdAt, name: String

    enum CodingKeys: String, CodingKey {
        case id
        case metadataPrivate = "private"
        case createdAt, name
    }
}

struct Record: Codable {
    let name: String
    let reps: [Reporter]
    let defState, state: String
}
