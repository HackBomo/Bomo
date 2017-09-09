//
//  ViewController.swift
//  VuforiaSample
//
//  Created by Yoshihiro Kato on 2016/07/02.
//  Copyright © 2016年 Yoshihiro Kato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let vuforiaLicenseKey = "AdNdvf//////AAAAGX73xujGC0bysCKLZBA64OEy16TIA5ZmV70H4YTYmkLFGTr/fGVBIEghyUqPX00RbK1rb1eS/YB1Szy8ncX4Ij6LmzTrqNoXSYh0AFbSg5Md6qr0WP68KEQqb5M0cvJnJG6yPte8jj6gfpFaQ7W9KpJdyPKNQ/McGah1EYMTrvP5LjM4oCgYJaPC62iPnRODg9fc3Ep0CWgDL5gR/ePBJ2IoSlibyw32hs/mpFE4RZfklrYKsVD3Mb3qiOEWFvcgA1LOyfrX7/RtWYqXA7ppeK0YJlWEXkQtRiVAHLSwhdvg2SlK3s6iusfgSXZ4ioveOi+LqLC+pDkFiik706acfEzc/B+380PyXCtJzhZetkpb"
	let vuforiaDataSetFile = "hackbomo-2.xml"
	
	var vuforiaManager: VuforiaManager? = nil
	
	var swiftRenderer: SCNRenderer?
	var time: CFAbsoluteTime?
	var scene = SCNScene()
	
	var nodes = [String: SCNNode]()
	var seen = [String]()
	var allNames = ["bomo-trackers-1","bomo-trackers-2","bomo-trackers-3","bomo-trackers-4"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//prep our scene
		
		let base = "bomo-trackers-"
		for i in 1...4{
			let currentName = base + "\(i)"
			print("adding node: \(currentName)")
			nodes[currentName] = SCNNode(geometry: SCNSphere(radius: 0.01))
			nodes[currentName]!.name = currentName
			nodes[currentName]!.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
		}
	
		prepare()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		do {
		try vuforiaManager?.stop()
		}catch let error {
		print("\(error)")
		}
	}
}

private extension ViewController {
	func prepare() {
		vuforiaManager = VuforiaManager(licenseKey: vuforiaLicenseKey, dataSetFile: vuforiaDataSetFile)
		if let manager = vuforiaManager {
			manager.delegate = self				//tell manager how to talk to us
			manager.eaglView.sceneSource = self	//tell eaglview how to talk to us
			manager.eaglView.delegate = self	//tell eagleview how to talk to us again
			manager.eaglView.setupRenderer()	//eaglview builds a renderer with our scene
			self.view = manager.eaglView
		}
		
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(didRecieveWillResignActiveNotification),
		                               name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
		
		notificationCenter.addObserver(self, selector: #selector(didRecieveDidBecomeActiveNotification),
		                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
		
		vuforiaManager?.prepare(with: .portrait)
	}
	func pause() {
		do {
			try vuforiaManager?.pause()
		}catch let error {
			print("\(error)")
		}
	}
	func resume() {
		do {
			try vuforiaManager?.resume()
		}catch let error {
			print("\(error)")
		}
	}
}
extension ViewController {
	func didRecieveWillResignActiveNotification(_ notification: Notification) {
		pause()
	}
	func didRecieveDidBecomeActiveNotification(_ notification: Notification) {
		resume()
	}
}
extension ViewController: VuforiaManagerDelegate {
	func vuforiaManagerDidFinishPreparing(_ manager: VuforiaManager!) {
		print("did finish preparing\n")
		
		do {
			try vuforiaManager?.start()
			vuforiaManager?.setContinuousAutofocusEnabled(true)
			
		}catch let error {
			print("\(error)")
		}
	}
	func vuforiaManager(_ manager: VuforiaManager!, didFailToPreparingWithError error: Error!) {
		print("did faid to preparing \(error)\n")
	}
	func vuforiaManager(_ manager: VuforiaManager!, didUpdateWith state: VuforiaState!) {
		//	print("looking at \(state.numberOfTrackableResults) trackables")
		
//		for index in 0 ..< state.numberOfTrackableResults {
//			guard let result = state.trackableResult(at: index) else{
//				continue
//			}
//			let name = result.trackable.name!
//			guard objects[name] == nil else{	//skip recognized objects
//				continue
//			}
//			print("number of trackables: \(state.numberOfTrackableResults)")
//			
//			
//			//create new scnnodes
//			let circle = SCNNode(geometry: SCNSphere(radius: 1))
//			let renderer: SCNRenderer = manager.eaglView.getRenderer()
//			renderer.scene?.rootNode.addChildNode(circle)
//			print("adding node on \(name)")
//			objects[name] = circle
//			
//			//let trackerableName = result?.trackable.name
//			if trackerableName == "stones" {
//			boxMaterial.diffuse.contents = UIColor.red
//			
//			if lastSceneName != "stones" {
//			manager.eaglView.setNeedsChangeSceneWithUserInfo(["scene" : "stones"])
//			lastSceneName = "stones"
//			}
//			}else {
//			boxMaterial.diffuse.contents = UIColor.blue
//			
//			if lastSceneName != "chips" {
//			manager.eaglView.setNeedsChangeSceneWithUserInfo(["scene" : "chips"])
//			lastSceneName = "chips"
//			}
//			}
//			
//		}
	}
	
	func vuforiaManager(_ manager: VuforiaManager!, didGetObject name: String!, withPosition swiftMatrix: SCNMatrix4) {
		seen.append(name)
		nodes[name]?.position = SCNVector3Make(swiftMatrix.m41, swiftMatrix.m42, swiftMatrix.m43)
		if nodes[name] == nil{
			print("node \(name) is null")
		}
	}

	//One more function to delete nodes that do not appear/are not recognized
	func vuforiaManager(_ manager: VuforiaManager!, finishedSendingObjects finished: Bool) {
		
		//remove, add, or keep nodes
		for node in nodes{
			if seen.contains(node.key) && node.value.parent == nil{
				scene.rootNode.addChildNode(node.value)
			}else if seen.contains(node.key){
				continue
			}else{
				node.value.removeFromParentNode()
			}
		}
		
		//remove cylinders
		for node in scene.rootNode.childNodes{
			if node.name == "cylinder"{
				node.removeFromParentNode()
			}
		}

		//draw cylinders
		for i in 0..<allNames.count - 1{
			let first = allNames[i]
			let second = allNames[i+1]
			
			if seen.contains(first) && seen.contains(second){
				drawCylinder(nodeA: nodes[first]!, nodeB: nodes[second]!)
			}
			
		}
		
		guard let swiftRenderer = manager.eaglView.getRenderer() else {
			print("Error, could not get renderer from eaglView")
			return
		}
		if time == nil{
			time = CFAbsoluteTimeGetCurrent()
		}
		let currentTime = CFAbsoluteTimeGetCurrent() - time!
		swiftRenderer.render(atTime: currentTime)
		seen = [String]()
	}
	func vuforiaManager(_ manager: VuforiaManager!, didGet context: EAGLContext!) {
		//NOT IN USE
	}
}
extension ViewController{	//MARK: Drawing Functions
	func drawCylinder(nodeA: SCNNode, nodeB: SCNNode) -> SCNNode{
		let positionStart = nodeA.position
		let positionEnd = nodeB.position
		
		let radius = CGFloat(0.005)
		let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(positionStart), SCNVector3ToGLKVector3(positionEnd)))
		
		let startNode = SCNNode()
		let endNode = SCNNode()
		startNode.position = positionStart
		endNode.position = positionEnd
		
		let zAxisNode = SCNNode()
		zAxisNode.eulerAngles.x = Float(CGFloat(M_PI_2))
		
		let cylinderGeometry = SCNCylinder(radius: radius, height: height)
		let cylinder = SCNNode(geometry: cylinderGeometry)
		cylinder.geometry?.firstMaterial?.diffuse.contents = UIColor.black
		
		cylinder.position.y = Float(-height/2)
		zAxisNode.addChildNode(cylinder)
		
		var returnNode = SCNNode()
		for node in returnNode.childNodes{
			node.removeFromParentNode()
		}
		
		if (positionStart.x > 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0){
			endNode.addChildNode(zAxisNode)
			endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
			returnNode.addChildNode(endNode)
			
		}else if (positionStart.x < 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0){
			endNode.addChildNode(zAxisNode)
			endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
			returnNode.addChildNode(endNode)
			
		}else if (positionStart.x < 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0){
			endNode.addChildNode(zAxisNode)
			endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
			returnNode.addChildNode(endNode)
			
		}else if (positionStart.x > 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0){
			endNode.addChildNode(zAxisNode)
			endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
			returnNode.addChildNode(endNode)
			
		}else{
			startNode.addChildNode(zAxisNode)
			startNode.constraints = [ SCNLookAtConstraint(target: endNode) ]
			returnNode.addChildNode(startNode)
		}
		
		returnNode.name = "cylinder"
		self.scene.rootNode.addChildNode(returnNode)
		//print("drew line at position \(cylinder.position)")
		return returnNode
	}

}
extension ViewController: VuforiaEAGLViewSceneSource, VuforiaEAGLViewDelegate {
	
	func scene(for view: VuforiaEAGLView!) -> SCNScene! {
		//return our scene. EAGLView will take care of the camera
		return self.scene
	}
	func vuforiaEAGLView(_ view: VuforiaEAGLView!, didTouchDownNode node: SCNNode!) {
		print("touch down \(node.name ?? "")\n")
	}
	func vuforiaEAGLView(_ view: VuforiaEAGLView!, didTouchUp node: SCNNode!) {
		print("touch up \(node.name ?? "")\n")
	}
	func vuforiaEAGLView(_ view: VuforiaEAGLView!, didTouchCancel node: SCNNode!) {
		print("touch cancel \(node.name ?? "")\n")
	}
}


