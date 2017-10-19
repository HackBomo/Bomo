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
import MessageUI

protocol CellButtonDelegate {
	func buttonPressed(sender: Any)
}

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

	@IBAction func starSessionPressed(sender: AnyObject){
		self.performSegue(withIdentifier: "segueVuforiaVC", sender: self)
	}

	@IBAction func exportAllPressed(sender: AnyObject){
		guard profileID != nil else {
			NSLog("Error exporting in subjectDetailVC")
			return
		}
		exportAllSessions(for: profileID!)
	}

	
	func createSession() -> String?{
		do{
			let realm = try Realm()
			guard let profile = realm.object(ofType: Profile.self, forPrimaryKey: profileID) else{
				NSLog("Error creating session, could not get user profile")
				return nil
			}
			let session = Session()
			try realm.write {
				session.owner = profile
				profile.sessions.append(session)
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
			vc.sessionID = createSession()
			NSLog("Successfully created a new session")
		}
	}

	func deleteSession(with id: String){
		do{
			let realm = try Realm()
			guard let session = realm.object(ofType: Session.self, forPrimaryKey: id) else{
				NSLog("eror deleting session, not found")
				return
			}
			try realm.write {
				realm.delete(session)
			}
		}catch{
			NSLog("Error deleting session")
		}
	}
	func exportAllSessions(for profileID: String){
		guard MFMailComposeViewController.canSendMail() else{
			NSLog("Cannot export data, unable to send data")
			return
		}
        
        let emailController = MFMailComposeViewController()
        emailController.mailComposeDelegate = self
        emailController.setToRecipients([]) //I usually leave this blank unless it's a "message the developer" type thing
        emailController.setMessageBody("Data Attached", isHTML: false)

		
		do{
			let realm = try Realm()
            
			guard let profile = realm.object(ofType: Profile.self, forPrimaryKey: profileID) else{
				NSLog("Error exporting profile sessions, can't find profile")
				return
			}
            
            emailController.setSubject("Subject \(profile.subjectNumber) All Session Data")

			
			for session in profile.sessions{
				let df = DateFormatter()
				df.dateFormat = "y-MM-dd H:m:ss.SSSS"
				var dataString = NSMutableString()
				dataString.append("Date, angle, x1, y1, z1, x2, y2, z2, x3, y3, z3\n")
				for dp in session.dataPoints{
					dataString.append("\(df.string(from: dp.startTime!)), \(dp.angle), \(dp.x1), \(dp.y1), \(dp.z1), ")
					dataString.append("\(dp.x2), \(dp.y2), \(dp.z2), \(dp.x3), \(dp.y3), \(dp.z3)\n")
				}
				guard let data = dataString.data(using: 4, allowLossyConversion: false) else{ //4 represents UTF 8
					NSLog("Error creating data from session")
					continue
				}
				df.dateStyle = .short
				df.timeStyle = .short
				let fileName = "\(session.owner!.subjectNumber)_\(df.string(from: session.startTime)).csv"
				emailController.addAttachmentData(data, mimeType: "text/csv", fileName: fileName)
				
			}
            
			self.present(emailController, animated: true, completion: nil)
            
		}catch{
			NSLog("Error exporting data, can't open realm: \(error)")
		}
	}
	func exportSessionData(sessionId: String){
		do{
			let realm = try Realm()
			guard let session = realm.object(ofType: Session.self, forPrimaryKey: sessionId) else{
				NSLog("Error exporting session, can't find session")
				return
			}
			guard session.startTime != nil else{
				NSLog("Error exporting session, start time nil")
				return
			}
			
			let df = DateFormatter()
			df.dateFormat = "y-MM-dd H:m:ss.SSSS"
			
			var dataString = NSMutableString()
			dataString.append("Date, angle, x1, y1, z1, x2, y2, z2, x3, y3, z3\n")
			for dp in session.dataPoints{
				dataString.append("\(df.string(from: dp.startTime!)), \(dp.angle), \(dp.x1), \(dp.y1), \(dp.z1), ")
				dataString.append("\(dp.x2), \(dp.y2), \(dp.z2), \(dp.x3), \(dp.y3), \(dp.z3)\n")
			}
			
			guard let data = dataString.data(using: 4, allowLossyConversion: false) else{ //4 represents UTF 8
				NSLog("Error creating data from session")
				return
			}
			
			df.dateStyle = .short
			df.timeStyle = .short
			let fileName = "\(session.owner!.subjectNumber)_\(df.string(from: session.startTime)).csv"
			
			if MFMailComposeViewController.canSendMail() {
				let emailController = MFMailComposeViewController()
				emailController.mailComposeDelegate = self
				emailController.setToRecipients([]) //I usually leave this blank unless it's a "message the developer" type thing
				emailController.setSubject("\(df.string(from: session.startTime)) Subject \(session.owner!.subjectNumber) data")
				emailController.setMessageBody("Data Attached", isHTML: false)
				emailController.addAttachmentData(data, mimeType: "text/csv", fileName: fileName)
				present(emailController, animated: true, completion: nil)
			}
		}catch{
			NSLog("Error exporting data, can't open realm: \(error)")
		}
	}
	 @IBAction func unwindToSubjectDetailVC(segue: UIStoryboardSegue) {
		self.loadSubject()
		self.tableView.reloadData()
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
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete{
			let cell = tableView.cellForRow(at: indexPath) as! SessionCell
			guard let id = cell.sessionID else{
				NSLog("Unable to delte session, cannot get session ID from cell")
			}
			deleteSession(with: id)
		}
	}
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
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
        cell.delegate = self
        return cell
	}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

extension SubjectDetailViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: Error?) {
        
		print("Dismissing mail view controller")
        controller.dismiss(animated: true, completion: nil)

		NSLog("\n\n\n\n\n\nDismissing mail view controller\n\n\n\n\n\n")
		controller.dismiss(animated: true, completion: nil)
	}
}

extension SubjectDetailViewController: CellButtonDelegate{
	func buttonPressed(sender: Any) {
		guard let id = sender as? String else {
			NSLog("Error exporting data, delegate cannot convert string")
			return
		}
		exportSessionData(sessionId: id)
	}
}
