//
//  StartScreenViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 07..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import SwipeCellKit

class FeedScreenViewController: UIViewController {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var challengeId: String = ""
    var realm = try! Realm()
    var challenges: Results<Challenge>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        //fetching
        if !realm.isEmpty {
            loadChallenges()
        }
        else {
            fetchChallenges()
        }
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNib, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare() called")
        
        let identifier = segue.identifier ?? ""
        print(identifier)
        if identifier == K.Segues.challengeDetails {
            if let indexPath = tableView.indexPathForSelectedRow {
                print("inside")
                ChallengeManager.shared.challengeId = challenges[indexPath.row].firebaseId
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func loadChallenges() {
        challenges = realm.objects(Challenge.self)
        print("loadChallenges() called")
        print(challenges.count)
        self.tableView.reloadData()
    }
    
    func fetchChallenges() {
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        print("fetchChallenges() called")
        
        ref.child("users").child(userID!).child("challenges").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                
                let realmChallenge = Challenge()
                let snap = child as! DataSnapshot
                let challengeDict = snap.value as! [String: Any]
                //let jsonString = snap.value as! String
                
                realmChallenge.name = challengeDict["name"] as! String
                realmChallenge.distance = challengeDict["dst"] as! Double
                realmChallenge.duration = challengeDict["dur"] as! Double
                realmChallenge.maxSpeed = challengeDict["ms"] as! Double
                realmChallenge.type = challengeDict["type"] as! String
                realmChallenge.averageSpeed = challengeDict["avg"] as! Double
                realmChallenge.firebaseId = challengeDict["firebaseId"] as! String
                realmChallenge.date = challengeDict["date"] as! String
                let routeAsString = challengeDict["routeAsString"] as! String
                //print(routeAsString)
                let jsonData = routeAsString.data(using: .utf8)!
                let decoder = JSONDecoder()
                
                do {
                    let myLocationArray = try decoder.decode([FirebaseMyLocation].self, from: jsonData)
                    for myFirebaseLocation in myLocationArray {
                        let myLocation = MyLocation()
                        myLocation.altitude = myFirebaseLocation.altitude
                        myLocation.distance = myFirebaseLocation.distance
                        myLocation.latitude = myFirebaseLocation.latLng.latitude
                        myLocation.longitude = myFirebaseLocation.latLng.longitude
                        myLocation.speed = myFirebaseLocation.speed
                        myLocation.time = myFirebaseLocation.time
                        realmChallenge.route.append(myLocation)
                    }
                    try! self.realm.write{
                        self.realm.add(realmChallenge)
                    }
                } catch {
                    print(error)
                }
                
            }
            self.loadChallenges()
        })
    }
}

extension FeedScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(challenges.count)
        return challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ChallengeTableViewCell
        cell.delegate = self
        
        let challenge = challenges[indexPath.row]
        
        cell.titleLabel.text = challenge.name
        cell.distanceLabel.text = "Distance: " + challenge.distance.format(f: ".1") + "km"
        cell.durationLabel.text = "Duration: " + challenge.duration.toTime()
        
        return cell
    }
    
}

extension FeedScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: K.Segues.challengeDetails, sender: self)
        
    }
}

extension FeedScreenViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let challengeName = self.challenges[indexPath.row].name
            ChallengeManager.shared.delete(challenge: self.challenges[indexPath.row])
            Utils.showToast(controller: self, message: "Challenge \(challengeName) was deleted successfully!", seconds: 2)
            //haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            self.tableView.reloadData()
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
}


