//
//  SubjectDetailViewController.swift
//  VuforiaSampleSwift
//
//  Created by Tyler Angert on 10/18/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SubjectDetailViewController: UIViewController {
	
	var profileID: String?
	var subject: Profile?
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	func createSession() -> String?{
		do{
			let realm = try Realm()
			let session = Session()
			try realm.write {
				realm.add(session)
			}
			return session.id
		}catch{
			NSLog("Error loading subjets in AllSubjectsViewController")
		}
		return nil
	}
	func deleteSession(sessionID: String) -> Bool{
		do{
			let realm = try Realm()
			guard let session = realm.object(ofType: Session.self, forPrimaryKey: sessionID) else{
				NSLog("Unable to delete session, can't find object")
				return false
			}
			try realm.write {
				realm.delete(session)
			}
			return true
		}catch{
			NSLog("Error deleting session in subjectDetailVC")
		}
		return false
	}
	
	func loadSubject() -> Profile?{
		guard profileID != nil else{
			NSLog("Cannot load subject in SubjectDetailsVC because profileID is nil")
			return nil
		}
		do{
			let realm = try Realm()
			self.subject = realm.object(ofType: Profile.self, forPrimaryKey: profileID!)
		}catch{
			NSLog("Error loading subjets in AllSubjectsViewController")
		}
		return subject
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueVuforiaVC"{
			let vc = segue.destination as! VuforiaViewController
			vc.profileID = self.profileID
			vc.sessionID = sender as! String
		}
	}
    
}
