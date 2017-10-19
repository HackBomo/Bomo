//
//  SessionCell.swift
//  VuforiaSampleSwift
//
//  Created by Tyler Angert on 10/18/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SessionCell: UITableViewCell {
    
    // MARK: Realm references
    var sessionID: String?
    
    // MARK: IBOutlets
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var exportButton: UIButton!
    
    override func awakeFromNib() {
        exportButton.layer.cornerRadius = 10
        exportButton.clipsToBounds = true
    }
    
    // MARK: IBActions

    @IBAction func exportPressed(_ sender: Any) {
		exportSessionData(sessionId: sessionID)
    }
	
	func exportSessionData(sessionId: String){
		do{
			let realm = try Realm()
			guard let session = realm.object(ofType: Session.self, forPrimaryKey: sessionID) else{
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
			dataString.append("Date, x1, y1, z1, x2, y2, z2, x3, y3, z3\n")
			for dp in session.dataPoints{
				dataString.append("\(df.string(from: dp.startTime!)), \(dp.x1), \(dp.y1), \(dp.z1), ")
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
    
}
