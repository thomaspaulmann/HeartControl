//
//  HKUnit+BeatsPerMinute.swift
//  Heart Control
//
//  Created by Thomas Paul Mann on 01/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import HealthKit

extension HKUnit {

    static func beatsPerMinute() -> HKUnit {
        return HKUnit.count().unitDivided(by: HKUnit.minute())
    }
    
}
