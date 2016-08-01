//
//  HKWorkoutSessionState+Description.swift
//  Heart Control
//
//  Created by Thomas Paul Mann on 01/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import HealthKit

extension HKWorkoutSessionState {

    func description() -> String {
        switch self {
        case .ended:
            return "ended"
        case .notStarted:
            return "notStarted"
        case .paused:
            return "paused"
        case .running:
            return "running"
        }
    }
    
}
