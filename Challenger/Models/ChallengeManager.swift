//
//  ChallengeManager.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 25..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import RealmSwift

class ChallengeManager {
    
    private let realm = try! Realm()
    var challengeId: String
    static let shared = ChallengeManager()
    
    private init() {
        self.challengeId = ""
    }
    
    func getChallenge(id: String) -> Challenge? {
        realm.object(ofType: Challenge.self, forPrimaryKey: id)
    }
    
    func getChallenge() -> Challenge? {
        return realm.object(ofType: Challenge.self, forPrimaryKey: challengeId)
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
    
    func delete(challenge: Challenge) {
        do {
            try realm.write {
                realm.delete(challenge)
            }
        } catch  {
            print(error)
        }
    }
    
    func rename(challenge: Challenge, name: String) {
        do {
            try realm.write {
                challenge.name = name
            }
        } catch {
            print(error)
        }
    }
    
    func save(challenge: Challenge) {
        do {
            try realm.write{
                realm.add(challenge)
            }
        } catch  {
            print(error)
        }
    }
}
