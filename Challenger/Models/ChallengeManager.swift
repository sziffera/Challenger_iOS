//
//  ChallengeManager.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 25..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import RealmSwift

//Manages challenges across activities, only the id is stored to save memory

class ChallengeManager {
    
    private lazy var realm = try! Realm()
    var challengeId: String ///id for the currently selected challenge
    var isDiscard: Bool = false
    var comparedChallengeId: String
    static let shared = ChallengeManager()
    
    private(set) var cadenceSensorConnected: Bool
    private(set) var heartRateSensorConnected: Bool
    
    private var challengeHelperCounter = 0
    
    //Creating a challenge -- helper variables
    var duration: Double
    var distance: Double
    var isChallenge: Bool
    
    private init() {
        self.comparedChallengeId = ""
        self.challengeId = ""
        self.distance = 0
        self.duration = 0
        self.isChallenge = false
        self.heartRateSensorConnected = false
        self.cadenceSensorConnected = false
    }
    
    func getChallenge(id: String) -> Challenge? {
        realm.object(ofType: Challenge.self, forPrimaryKey: id)
    }
    
    func getChallenge() -> Challenge? {
        return realm.object(ofType: Challenge.self, forPrimaryKey: challengeId)
    }
    
    func getChallengedActivity() -> Challenge? {
        return realm.object(ofType: Challenge.self, forPrimaryKey: comparedChallengeId)
    }
    
    func getCurrentChallengeRouteSize() -> Int {
        return realm.object(ofType: Challenge.self, forPrimaryKey: challengeId)?.route.count ?? 0
    }
    
    func getTimeDifference(location: MyLocation) -> Double? {
        if let _ = getChallenge() {
            while challengeHelperCounter < getChallenge()!.route.count {
                if location.distance > getChallenge()!.route[challengeHelperCounter].distance {
                    return getChallenge()!.route[challengeHelperCounter].time - location.time
                }
                challengeHelperCounter += 1
            }
        }
        return nil
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
    
    func delete() {
        do {
            try realm.write {
                if let challenge = getChallenge() {
                    realm.delete(challenge)
                }
            }
        } catch  {
            print(error)
        }
    }
    
    func rename(name: String) {
        do {
            try realm.write {
                self.getChallenge()?.name = name
            }
        } catch {
            print(error)
        }
    }
    
    ///saves the challenge into the Realm db and sets the challenge id
    func save(challenge: Challenge) {
        ///saves challenge on the main thread to avoid 'realm accessed from wrong thread' exception
               
        do {
            try self.realm.write{
                self.realm.add(challenge)
            }
            self.challengeId = challenge.firebaseId
        } catch  {
            print(error)
        }
    }
    
    func heartRateSensorDidConnect() {
        heartRateSensorConnected = true
    }
    func cadenceSensorDidConnect() {
        cadenceSensorConnected = true
    }
    
    func heartRateSensorDidDisConnect() {
        heartRateSensorConnected = false
    }
    func cadenceSensorDidDisConnect() {
        cadenceSensorConnected = false
    }
    
    
}
