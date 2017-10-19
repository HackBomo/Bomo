//
//  Session.swift
//  VuforiaSampleSwift
//
//  Created by Jake Cronin on 9/10/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import RealmSwift

class Session: Object{
	
	dynamic var owner: Profile?
	dynamic var startTime = Date()
	let dataPoints = List<DataPoint>()
	
	@objc dynamic var id = NSUUID().uuidString
	override static func primaryKey() -> String? {
		return "id"
	}
	
	
	
}
