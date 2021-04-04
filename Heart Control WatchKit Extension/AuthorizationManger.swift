//
//  HKAuthorizationManger.swift
//  Heart Control
//
//  Created by Thomas Paul Mann on 07/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import HealthKit

class AuthorizationManager {

    static func requestAuthorization(completionHandler: @escaping ((_ success: Bool) -> Void)) {
        // Create health store.
        let healthStore = HKHealthStore()

        // Check if there is health data available.
        if (!HKHealthStore.isHealthDataAvailable()) {
            print("No health data is available.")
            completionHandler(false)
            return
        }

        // Create quantity type for heart rate.
        guard let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            print("Unable to create quantity type for heart rate.")
            completionHandler(false)
            return
        }

        // Request authorization to read heart rate data.
        healthStore.requestAuthorization(toShare: nil, read: [heartRateQuantityType]) { (success, error) -> Void in
            // If there is an error, do nothing.
            guard error == nil else {
//                print(error)
                completionHandler(false)
                return
            }

            // Delegate success.
            completionHandler(success)
        }
    }

}
