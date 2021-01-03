//
//  ChallengeDetailsViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 21..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class ChallengeDetailsViewController: UIViewController {
    
    private var details: [Detail] = [Detail]()
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView6: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    @IBOutlet weak var stackView7: UIStackView!
    @IBOutlet weak var stackView8: UIStackView!
    @IBOutlet weak var stackView9: UIStackView!
    @IBOutlet weak var stackView10: UIStackView!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var elevGainLabel: UILabel!
    @IBOutlet weak var elevLossLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var maxPaceLabel: UILabel!
    @IBOutlet weak var avgBPMLabel: UILabel!
    @IBOutlet weak var avgRPMLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        discardButton.isHidden = !ChallengeManager.shared.isDiscard
        
        discardButton.layer.cornerRadius = 5
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        
        gradientLayer.shouldRasterize = true
        //backgroundGradientView.layer.addSublayer(gradientLayer)
        
        let stackList = [stackView,stackView2,stackView3,stackView4,stackView5,stackView6,stackView7,stackView8,stackView9,stackView10]
        
        for stackView in stackList {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(named: K.Color.darkBlue)
            backgroundView.layer.cornerRadius = 15
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            // put background view as the most background subviews of stack view
            stackView!.insertSubview(backgroundView, at: 0)
                   // pin the background view edge to the stack view edge
            NSLayoutConstraint.activate([
                       backgroundView.leadingAnchor.constraint(equalTo: stackView!.leadingAnchor),
                       backgroundView.trailingAnchor.constraint(equalTo: stackView!.trailingAnchor),
                       backgroundView.topAnchor.constraint(equalTo: stackView!.topAnchor),
                       backgroundView.bottomAnchor.constraint(equalTo: stackView!.bottomAnchor)
                   ])
        }
        
        guard let challenge = ChallengeManager.shared.getChallenge() else { return }
        
        distanceLabel.text = challenge.distance.km()
        durationLabel.text = challenge.duration.toTime()
        averageSpeedLabel.text = challenge.averageSpeed.speed()
        maxSpeedLabel.text = challenge.maxSpeed.speed()
        let pace: Double = challenge.duration / challenge.distance
        avgPaceLabel.text = pace.toPace()
        
//        let avgPace = challenge.duration / challenge.distance
        
//        details = [
//            Detail(field: "Distance", value: challenge.distance.km()),
//            Detail(field: "Duration", value: challenge.duration.toTime()),
//            Detail(field: "Average speed", value: challenge.averageSpeed.format(f: "1") + " km/h"),
//            Detail(field: "Max speed", value: challenge.maxSpeed.format(f: "1") + " km/h"),
//            Detail(field: "Avg pace", value: avgPace.toPace())
//        ]
        
        //        tableView.dataSource = self
        //        tableView.register(UINib(nibName: K.detailsCellNib, bundle: nil), forCellReuseIdentifier: K.detailCellIdentifier)
    }
    
    @IBAction func discardButtonPressed(_ sender: UIButton) {
        ChallengeManager.shared.delete()
        self.performSegue(withIdentifier: K.Segues.discardPressed, sender: nil)
    }
}

extension ChallengeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.detailCellIdentifier, for: indexPath) as! DetailTableViewCell
        
        cell.fieldLabel.text = details[indexPath.row].field
        cell.valueLabel.text = details[indexPath.row].value
        
        return cell
    }
}

private struct Detail {
    let field: String
    let value: String
}
