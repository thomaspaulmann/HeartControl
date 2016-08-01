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

    // MARK: - Properties

    private let healthStore = HKHealthStore()
    private var workoutStartDate: Date?

    // MARK: - Lifecycle

    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)

    }
    
    override func willActivate() {
        super.willActivate()

        // Workout Configuration

        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .indoor

        // Start Workout

        do {
            let workoutSession = try HKWorkoutSession(configuration: workoutConfiguration)

            workoutSession.delegate = self

            healthStore.start(workoutSession)
        } catch {
            // ...
        }

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

// MARK: - Workout Session Delegate

extension InterfaceController: HKWorkoutSessionDelegate {

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {

    }


    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: NSError) {

    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {

    }

}
