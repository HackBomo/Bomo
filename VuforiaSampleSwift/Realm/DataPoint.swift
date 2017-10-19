//
//  DataPoint.swift
//  VuforiaSampleSwift
//
//  Created by Jake Cronin on 10/17/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import RealmSwift

class DataPoint: Object{
	
	dynamic var startTime: Date?
	
    dynamic var angle: Double = 0
    
	dynamic var x1: Double = 0
	dynamic var y1: Double = 0
	dynamic var z1: Double = 0
	
	dynamic var x2: Double = 0
	dynamic var y2: Double = 0
	dynamic var z2: Double = 0
	
	dynamic var x3: Double = 0
	dynamic var y3: Double = 0
	dynamic var z3: Double = 0
	
}
