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

    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var controlButton: WKInterfaceButton!

    // MARK: - Properties

    private let workoutManager = WorkoutManager()

    // MARK: - Actions

    @IBAction func didTapButton() {
        switch workoutManager.state {
        case .started:
            // Stop current workout.
            workoutManager.stop()

            // Update title of control button.
            controlButton.setTitle(workoutManager.state.actionText())

            break
        case .stopped:
            // Start new workout.
            workoutManager.start()

            // Update title of control button.
            controlButton.setTitle(workoutManager.state.actionText())

            break
        }
    }

}
