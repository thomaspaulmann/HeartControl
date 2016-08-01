//
//  InterfaceController.swift
//  Heart Control WatchKit Extension
//
//  Created by Thomas Paul Mann on 01/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {

    // MARK: - Outlets

    @IBOutlet var workoutStatusLabel: WKInterfaceLabel!

    // MARK: - Properties

    private let workoutManager = WorkoutManager()

    // MARK: - Lifecycle

    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK: - Actions

    @IBAction func didTapStartButton() {
        workoutManager.start()

        workoutStatusLabel.setText("Started...")
    }

    @IBAction func didTapPauseButton() {
        workoutManager.pause()

        workoutStatusLabel.setText("Paused.")
    }

    @IBAction func didTapEndButton() {
        workoutManager.end()

        workoutStatusLabel.setText("Ended!")
    }

}
