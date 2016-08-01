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
    private var activeQueries = [HKQuery]()

    // MARK: - API

    func requestAuthorization() {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        healthStore.requestAuthorization(toShare: nil, read: [quantityType]) { (success, error) -> Void in
//            if success == false {
//                fatalError()
//            }
        }
    }

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

    // MARK: - Query

    func startQueries() {
        startQuery(for: .heartRate)
        startQuery(for: .respiratoryRate)
        startQuery(for: .oxygenSaturation)
    }

    func startQuery(for quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        // Configure the quantity type.
        guard let quantityType = HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier) else { return }

        // Create the query.
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = CompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, NSError?) -> Void = { query, samples, deletedObjects, queryAnchor, error in
            // Process samples
            print(samples)
        }
        let query = HKAnchoredObjectQuery(type: quantityType,
                                          predicate: queryPredicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit,
                                          resultsHandler: updateHandler)
        query.updateHandler = updateHandler

        // Execute the heart rate query.
        healthStore.execute(query)

        activeQueries.append(query)
    }

    func stopQueries() {
        activeQueries.forEach { healthStore.stop($0) }
    }

}

// MARK: - Workout Session Delegate

extension WorkoutManager: HKWorkoutSessionDelegate {

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Switch to \(toState.description()) from \(fromState.description())")

        switch toState {
        case .running:
            if fromState == .notStarted {
                stopQueries()
            }

        case .ended:
            stopQueries()

        default:
            break
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        fatalError(error.localizedDescription)
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        print("Did generate \(event)")
    }
    
}
