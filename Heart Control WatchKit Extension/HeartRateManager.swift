//
//  HeartRateManager.swift
//  Heart Control
//
//  Created by Thomas Paul Mann on 01/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import HealthKit

typealias HKQueryUpdateHandler = (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, NSError?) -> Void

struct HeartRate {

    let timestamp: Date
    let bpm: Double

}

protocol HeartRateDelegate: class {

    func heartRate(didChangeTo newHeartRate: HeartRate)

}

class HeartRateManager {

    // MARK: - Properties

    private lazy var heartRateQuantityType: HKObjectType = {
        return HKObjectType.quantityType(forIdentifier: .heartRate)!
    }()

    private let healthStore = HKHealthStore()

    weak var delegate: HeartRateDelegate?

    private var activeQueries = [HKQuery]()

    // MARK: - Initialization

    init() {
        if (healthStore.authorizationStatus(for: heartRateQuantityType) != .sharingAuthorized) {
            requestAuthorization()
        }
    }

    // MARK: - Public API

    func requestAuthorization() {
        healthStore.requestAuthorization(toShare: nil, read: [heartRateQuantityType]) { (success, error) -> Void in
            if success == false {
                fatalError("Unable to request authorization of Health.")
            }
        }
    }

    func start() {
        // If not authorized to read heart rate, try one more time.
        if (healthStore.authorizationStatus(for: heartRateQuantityType) != .sharingAuthorized) {
            requestAuthorization()
        }

        // Configure heart rate quantity type.
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        // Create query to receive continiuous heart rate samples.
        let datePredicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = CompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        let updateHandler: HKQueryUpdateHandler = { [weak self] query, samples, deletedObjects, queryAnchor, error in
            if let quantitySamples = samples as? [HKQuantitySample] {
                self?.process(samples: quantitySamples)
            }
        }
        let query = HKAnchoredObjectQuery(type: quantityType,
                                          predicate: queryPredicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit,
                                          resultsHandler: updateHandler)
        query.updateHandler = updateHandler

        // Execute the heart rate query.
        healthStore.execute(query)

        // Remember all active Queries to stop them later.
        activeQueries.append(query)
    }

    func stop() {
        activeQueries.forEach { healthStore.stop($0) }
        activeQueries.removeAll()
    }

    // MARK: - Process

    private func process(samples: [HKQuantitySample]) {
        // Process every single sample.
        samples.forEach { process(sample: $0) }
    }

    private func process(sample: HKQuantitySample) {
        // If sample is not a heart rate sample, then do nothing.
        if (sample.quantityType != HKObjectType.quantityType(forIdentifier: .heartRate)) {
            return
        }

        // If sample is not compatible with beats per minute, then do nothing.
        if (!sample.quantity.is(compatibleWith: HKUnit.beatsPerMinute())) {
            return
        }

        // Extract information from sample.
        let timestamp = sample.endDate
        let count = sample.quantity.doubleValue(for: .beatsPerMinute())

        // Delegate new heart rate.
        let newHeartRate = HeartRate(timestamp: timestamp, bpm: count)
        delegate?.heartRate(didChangeTo: newHeartRate)
    }


}
