//
//  RealmManager.swift
//  VuforiaSampleSwift
//
//  Created by Jake Cronin on 9/9/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import RealmSwift


class RealmManager{
	
	static func startSession() -> Session{
		return Session()
	}
	static func endSession(session: Session) -> Bool{
		do{
			let realm = try Realm()
			try realm.write {
				realm.add(session)
			}
			return true
		}catch{
			print(error)
			return false
		}
		
	}
	
}
