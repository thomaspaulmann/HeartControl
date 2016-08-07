//
//  InterfaceController.swift
//  Heart Control WatchKit Extension
//
//  Created by Thomas Paul Mann on 01/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import WatchKit

class InterfaceController: WKInterfaceController {

    // MARK: - Outlets

    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var controlButton: WKInterfaceButton!

    // MARK: - Properties

    private let workoutManager = WorkoutManager()

    // MARK: - Lifecycle

    override func willActivate() {
        super.willActivate()

        // Configure workout manager.
        workoutManager.delegate = self
    }

    // MARK: - Actions

    @IBAction func didTapButton() {
        switch workoutManager.state {
        case .started:
            // Stop current workout.
            workoutManager.stop()
            break
        case .stopped:
            // Start new workout.
            workoutManager.start()
            break
        }
    }

}

// MARK: - Workout Manager Delegate

extension InterfaceController: WorkoutManagerDelegate {

    func workoutManager(_ manager: WorkoutManager, didChangeStateTo newState: WorkoutState) {
        // Update title of control button.
        controlButton.setTitle(newState.actionText())
    }

    func workoutManager(_ manager: WorkoutManager, didChangeHeartRateTo newHeartRate: HeartRate) {
        // Update heart rate label.
        heartRateLabel.setText(String(format: "%.0f", newHeartRate.bpm))
    }

}
