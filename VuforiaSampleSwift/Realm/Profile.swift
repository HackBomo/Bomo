//
//  Profile.swift
//  VuforiaSampleSwift
//
//  Created by Jake Cronin on 10/18/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object{
	
	@objc dynamic var subjectNumber = ""
	let sessions = List<Session>()
	let id = NSUUID().uuidString
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	
}
