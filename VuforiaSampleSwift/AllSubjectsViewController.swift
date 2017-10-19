//
//  AllSubjectsViewController.swift
//  VuforiaSampleSwift
//
//  Created by Tyler Angert on 10/18/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AllSubjectsViewController: UIViewController {
	
	var subjects: Results<Profile>?
	@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSubjectButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
		loadSubjects()
    }
	
	func loadSubjects(){
		do{
			let realm = try Realm()
			subjects = realm.objects(Profile.self)
		}catch{
			NSLog("Error loading subjets in AllSubjectsViewController")
		}
	}
    
    // MARK: IBActions
	func deleteUser(with id: String){
		do{
			let realm = try Realm()
			guard let user = realm.object(ofType: Profile.self, forPrimaryKey: id) else{
				NSLog("Error deleting user, not found")
				return
			}
			try realm.write {
				realm.delete(user)
			}
		}catch{
			NSLog("Error deleting user")
		}
	}
	
    @IBAction func pressCreateSubject(_ sender: Any) {
        
        //display alert view with text field
        //completion handler pass in the text to create subject
        
        let alert = UIAlertController(title: "Create test subject", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alert.textFields?[0] {
                
                // Create the subject with the test field
                self.createSubject(subjectNumber: field.text!)
                self.tableView.reloadData()
                
            } else {
                print("not filled in")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter subject ID here"
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueSubjectDetailVC"{
			let vc = segue.destination as! SubjectDetailViewController 
            vc.profileID = (sender as! TestSubjectCell).testSubjectID!
		}
	}
	
    // MARK: Realm functions
    
	func createSubject(subjectNumber: String){
		do{
			let realm = try Realm()
			let profile = Profile()
			profile.subjectNumber = subjectNumber
			try realm.write {
				realm.add(profile)
			}
		}catch{
			NSLog("Error creating subject in AllSubjectsVC")
		}
	}
	func deleteSubject(with profileID: String) -> Bool{
		do{
			let realm = try Realm()
			guard let profile = realm.object(ofType: Profile.self, forPrimaryKey: profileID) else{
				NSLog("Unable to delete profile, can't find object")
				return false
			}
			try realm.write {
				realm.delete(profile)
			}
			return true
		}catch{
			NSLog("Error loading subjets in AllSubjectsViewController")
		}
		return false
	}
}

extension AllSubjectsViewController: UITableViewDataSource, UITableViewDelegate {
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard subjects != nil else{
			NSLog("Cannot populate subject cells, subjects is nil")
			return 0
		}
		return subjects!.count
	}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard subjects != nil, subjects!.count > indexPath.row else{
			NSLog("Cannot make cell for profile")
			return UITableViewCell()
		}
		let profile = subjects![indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "testSubjectCell") as! TestSubjectCell
		cell.testSubjectID = profile.id
		cell.sessionsLabel.text = "Sessions: \(profile.sessions.count)"
		cell.subjectLabel.text = "Subject: \(profile.subjectNumber)"
		return cell
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete{
			let cell = tableView.cellForRow(at: indexPath) as! TestSubjectCell
			guard let id = cell.testSubjectID else{
				NSLog("Unable to delte user, cannot get session ID from cell")
				return
			}
			deleteUser(with: id)
			tableView.reloadData()

		}
	}
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
}




