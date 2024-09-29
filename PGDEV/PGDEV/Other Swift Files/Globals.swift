//
//  Globals.swift
//  PGDEV
//
//  Created by Family on 9/29/24.
//

import Foundation


let loadingGroup = DispatchGroup()


// MARK: - Settings -

// Variables

var autoReport = true
var autoRepFlag = 5
var autoRepPause = 10

// Functions



// MARK: - Reports -

// Variables

let checkRepAPIGroup = DispatchGroup()

let putRepAPIGroup = DispatchGroup()

var repPlayers: [Player] = []

var oldRepPlayers: [Player] = []

var repIndex = -1

func repsDefState() {
    for player in repPlayers {
        if autoReport {
            if player.reps >= autoRepPause {
                player.defState = "Paused"
            } else if player.reps >= autoRepFlag {
                player.defState = "Flagged"
            }
        } else {
            player.defState = "Reported"
        }
        
    }
}

// Functions

func reportersToCount(repts: [Reporter]) -> Int {
    var count = 0
    for reper in repts {
        if reper.valid == true {
            count += 1
        }
    }
    return count
}

func defStatePicker(index: Int) -> String {
    var state = "Reported"
    if autoReport {
        if repPlayers[index].reps >= autoRepPause {
            state = "Paused"
        } else if repPlayers[index].reps >= autoRepFlag {
            state = "Flagged"
        }
    }
    return state
}

func fetchRepAPIData(with url: String, headers: [String: String]) async throws {
    let apiURL = URL(string: url)!
    var request = URLRequest(url: apiURL)
    request.httpMethod = "GET"
    for (key, value) in headers {
        request.allHTTPHeaderFields = [key: value]
    }
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data,
           let dataStr = String(data: data, encoding: .utf8) {
            let repapi: RepAPI = {
                let json: String = """
                \(dataStr)
                """
                let record = json.data(using: .utf8)!
                return try! JSONDecoder().decode(RepAPI.self, from: record)
            }()
            var listOfPlayers: [Player] = []
            for player in repapi.record {
                if player != nil {
                    listOfPlayers.append(Player(pName: player!.name, reps: reportersToCount(repts: player!.reps), repts: player!.reps, defState: player!.defState, state: player!.state))
                }
            }
            repPlayers = listOfPlayers
            oldRepPlayers = []
            for player in listOfPlayers {
                oldRepPlayers.append(player)
            }
            print(oldRepPlayers[3].state)
            loadingGroup.leave()
        }
    }
    task.resume()
}

func putRepAPIData(with url: String, headers: [String: String]) async throws {
    let apiURL = URL(string: url)!
    var request = URLRequest(url: apiURL)
    request.httpMethod = "PUT"
    var repAPIData: [Record?] = [nil]
    for player in repPlayers {
        repAPIData.append(Record(name: player.pName, reps: player.repts, defState: player.defState, state: player.state))
    }
    let JSONdata = try! JSONEncoder().encode(repAPIData)
    request.httpBody = JSONdata
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    for (key, value) in headers {
        request.allHTTPHeaderFields = [key: value]
    }
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        putRepAPIGroup.leave()
    }
    task.resume()
}

func checkRepAPIData() async {
    let apiURL = URL(string: "https://api.jsonbin.io/v3/b/65c02b82dc74654018a05265")!
    var request = URLRequest(url: apiURL)
    request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-Master-Key": "This Was Removed For Privacy"]
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data,
           let dataStr = String(data: data, encoding: .utf8) {
            let repapi: RepAPI = {
                let json: String = """
                \(dataStr)
                """
                let record = json.data(using: .utf8)!
                return try! JSONDecoder().decode(RepAPI.self, from: record)
            }()
            var listOfPlayers: [Player] = []
            for player in repapi.record {
                if player != nil {
                    listOfPlayers.append(Player(pName: player!.name, reps: reportersToCount(repts: player!.reps), repts: player!.reps, defState: player!.defState, state: player!.state))
                }
            }
            if listOfPlayers != oldRepPlayers {
                print(listOfPlayers[3].state)
                for (index, player) in listOfPlayers.enumerated() {
                    if player != oldRepPlayers[index] {
                        repPlayers[index] = player
                    }
                }
                oldRepPlayers = listOfPlayers
            }
        }
        checkRepAPIGroup.leave()
    }
    task.resume()
}

// MARK: - Feedback -

// Variables



// Functions



