//
//  ARManager.swift
//  VuforiaSampleSwift
//
//  Created by Jake Cronin on 9/9/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation

protocol ARManagerDelegate {
	
}
class ARManager: NSObject{
	
	var licenseKey: String!
	var dataPath: String!
	
	var delegate: ARManagerDelegate?
	
	var vuforiaManager: VuforiaManager?
	
	init(licenseKey: String, dataPath: String) {
		super.init()
		self.licenseKey = licenseKey
		self.dataPath = dataPath
		
		vuforiaManager = initializeVuforiaManager()
		
		
		
	}
	
	func initializeVuforiaManager() -> VuforiaManager?{
		//FIXME: Build Function
		vuforiaManager = VuforiaManager(licenseKey: self.licenseKey, dataSetFile: self.dataPath)
		
		vuforiaManager?.delegate = self
		
		//init vuforia manager
		//set vuforiaManager.eaglView.delegate
		//do manager.eaglView.setupRenderer()
		//self.view = manager.eaglView??
		vuforiaManager?.prepare(with: .portrait)
		return vuforiaManager
	}
	
	func stop(){
		print("stop ar manager")
	}
	
	func drawScene(){
		///use scene renderer to
	}
	
}
extension ARManager: VuforiaManagerDelegate{
	func vuforiaManagerDidFinishPreparing(_ manager: VuforiaManager!) {
		print("Vuforia manager finished prepareing")
		
		do{
			try manager.start()
		}catch let error{
			print(error)
		}
	}
	func vuforiaManager(_ manager: VuforiaManager!, didFailToPreparingWithError error: Error!) {
		print("Failed to prepare the vuforia manager")
		print(error)
	}
	func vuforiaManager(_ manager: VuforiaManager!, didUpdateWith state: VuforiaState!) {
		print("Updated the state!!!")
	}
	
	
}
