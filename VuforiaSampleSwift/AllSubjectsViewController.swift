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
	
    override func viewDidLoad() {
        super.viewDidLoad()
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueSubjectDetailVC"{
			let vc = segue.destination as! SubjectDetailViewController
			vc.profileID = sender as! String
		}
	}
	
	func createSubject(subjectNumber: String){
		do{
			let realm = try Realm()
			let profile = Profile()
			profile.subjectNumber = subjectNumber
			try realm.write {
				realm.add(profile)
			}
			subjects = realm.objects(Profile.self)
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

extension AllSubjectsViewController: UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard subjects != nil else{
			NSLog("Cannot populate subject cells, subjects is nil")
			return 0
		}
		return subjects!.count
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
		cell.subjectLabel.text = "Subject Number: \(profile.subjectNumber)"
		return cell
	}
	
}




