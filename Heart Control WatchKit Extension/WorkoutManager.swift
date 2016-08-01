//
//  WorkoutManager.swift
//  Heart Control
//
//  Created by Thomas Paul Mann on 01/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import HealthKit

class WorkoutManager: NSObject {

    // MARK: - Properties

    private let healthStore = HKHealthStore()

    private var session: HKWorkoutSession?
    private var startDate: Date?

    // MARK: - API

    func start() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            // Another workout is running.
            return
        }

        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .indoor

        // Create workout session.
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session!.delegate = self

            startDate = Date()
        } catch {
            fatalError("Unable to create Workout Session!")
        }

        // Start workout session.
        healthStore.start(session!)
    }

    func pause() {
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }

        // Pause the workout session.
        healthStore.pause(session!)
    }

    func end() {
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }

        // Stop the workout session.
        healthStore.end(session!)

        // Clear the workout session.
        session = nil
    }

}


// MARK: - Workout Session Delegate

extension WorkoutManager: HKWorkoutSessionDelegate {

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Switch to \(toState.description()) from \(fromState.description())")
    }


    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        fatalError(error.localizedDescription)
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        print("Did generate \(event)")
    }
    
}
