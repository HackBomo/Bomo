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
	
    // MARK: Realm references
	var profileID: String?
	var subject: Profile?
	
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubject()
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

extension SubjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let subject = self.subject else {
            return 0
        }
        
        return subject.sessions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell") as! SessionCell
        
        guard let sessions = subject?.sessions else {
            return cell
        }
        
        let currentSession = sessions[indexPath.row]
        let id = currentSession.id
        
        cell.sessionID = id
        cell.sessionLabel.text = "Session: \(id)"
        cell.dateLabel.text = "Date: \(String(describing: currentSession.startTime))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
