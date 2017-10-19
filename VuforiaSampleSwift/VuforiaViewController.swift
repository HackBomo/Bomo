//
//  ViewController.swift
//  VuforiaSample
//
//  Created by Yoshihiro Kato on 2016/07/02.
//  Copyright © 2016年 Yoshihiro Kato. All rights reserved.
//

import UIKit
import SpriteKit
import RealmSwift
import MessageUI

protocol MainVCDelegate {
	func didCalculateAngle(angle: Float)
}

class VuforiaViewController: UIViewController {
	var hud: HudViewController?
	let nodeRadius = 1.0
	
	let vuforiaLicenseKey = "AdNdvf//////AAAAGX73xujGC0bysCKLZBA64OEy16TIA5ZmV70H4YTYmkLFGTr/fGVBIEghyUqPX00RbK1rb1eS/YB1Szy8ncX4Ij6LmzTrqNoXSYh0AFbSg5Md6qr0WP68KEQqb5M0cvJnJG6yPte8jj6gfpFaQ7W9KpJdyPKNQ/McGah1EYMTrvP5LjM4oCgYJaPC62iPnRODg9fc3Ep0CWgDL5gR/ePBJ2IoSlibyw32hs/mpFE4RZfklrYKsVD3Mb3qiOEWFvcgA1LOyfrX7/RtWYqXA7ppeK0YJlWEXkQtRiVAHLSwhdvg2SlK3s6iusfgSXZ4ioveOi+LqLC+pDkFiik706acfEzc/B+380PyXCtJzhZetkpb"
	let vuforiaDataSetFile = "hackbomo-3.xml"
	var vuforiaManager: VuforiaManager? = nil
	
	var delegate: MainVCDelegate?
	var currentSlideVal = 90
	var swiftRenderer: SCNRenderer?
	var time: CFAbsoluteTime?
	var scene = SCNScene()
	var nodes = [String: SCNNode]()
	var seen = [String]()
	var cylinderNodes = [SCNNode]()
	var angleNodes = [String: SCNNode]()	//string is the middle element of the angle
	
	var progressBarNode: SCNNode?
    var profileID: String?
    var sessionID: String?
	
	var allNames = ["bomo-trackers-1","bomo-trackers-2","bomo-trackers-3","bomo-trackers-4"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        self.navi
		startVuforia()
	}
	func startVuforia(){
		let base = "bomo-trackers-"
		for i in 1...4{
			let currentName = base + "\(i)"
			print("adding node: \(currentName)")
			nodes[currentName] = SCNNode(geometry: SCNSphere(radius: CGFloat(nodeRadius)))
			nodes[currentName]!.name = currentName
			nodes[currentName]!.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
		}
		prepare()
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("segueing")
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
	
	@IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
		performSegue(withIdentifier: "unwind", sender: self)
	}

}

extension VuforiaViewController: HudViewDelegate{
    
    func didSaveSession() {
        print("Saving from VC")
    }
    
    func didCancelSession() {
        print("Cancelling from VC")
    }
    
	func didDismiss() {
		performSegue(withIdentifier: "unwind", sender: self)
	}
    
}

private extension VuforiaViewController {
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
	func testTap(){
		print("view tapped")
	}
	func testHudTap(){
		print("hud tapped")
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

extension VuforiaViewController: VuforiaManagerDelegate {
	func vuforiaManagerDidFinishPreparing(_ manager: VuforiaManager!) {
		print("did finish preparing\n")
		do {
			try vuforiaManager?.start()
			vuforiaManager?.setContinuousAutofocusEnabled(true)
            
			DispatchQueue.main.async {
                
				self.hud = self.storyboard?.instantiateViewController(withIdentifier: "hud") as! HudViewController
				self.hud?.delegate = self
				self.delegate = self.hud
                
                self.present(self.hud!, animated: true, completion: {
                    print("presented the hud")
                })
			}

		}catch let error {
			print("\(error)")
		}
	}
	func vuforiaManager(_ manager: VuforiaManager!, didFailToPreparingWithError error: Error!) {
		print("did faid to preparing \(error)\n")
	}
	func vuforiaManager(_ manager: VuforiaManager!, didUpdateWith state: VuforiaState!) {
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
				let geometry = SCNSphere(radius: CGFloat(nodeRadius))
				geometry.firstMaterial?.diffuse.contents = UIColor(colorLiteralRed: 70/255, green: 201/255, blue: 242/255, alpha: 1)
				node.value.geometry = geometry
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
		
		//draw Angles
		for node in angleNodes.values{
			node.removeFromParentNode()
		}
        
		for i in 0..<seen.count{
			if i >= seen.count - 2{
				break
			}
            
			let a = nodes[allNames[i]]!
			let b = nodes[allNames[i+1]]!
			let c = nodes[allNames[i+2]]!
            
			let angle = getAngle(ankle: a.position, knee: b.position, hip: c.position)
        
			drawAngle(between: a, b: b, c: c, angle: angle)
            
			self.delegate?.didCalculateAngle(angle: angle)
		}
		
		guard let swiftRenderer = manager.eaglView.getRenderer() else {
			print("Error, could not get renderer from eaglView")
			return
		}
		if time == nil{
			time = CFAbsoluteTimeGetCurrent()
		}
		
		//Create new realm objects
		if profileID != nil && sessionID != nil{
			
			do{
				let realm = try Realm()
				guard let session = realm.object(ofType: Session.self, forPrimaryKey: sessionID) else{
					throw NSError(domain: "error getting session", code: 0, userInfo: nil)
				}
				
				let dataPoint = DataPoint()
				dataPoint.startTime = Date()
				
				if let n1 = nodes[allNames[0]]{
					dataPoint.x1 = Double(n1.position.x)
					dataPoint.y1 = Double(n1.position.y)
					dataPoint.z1 = Double(n1.position.z)
				}
				if let n2 = nodes[allNames[1]]{
					dataPoint.x2 = Double(n2.position.x)
					dataPoint.y2 = Double(n2.position.y)
					dataPoint.z2 = Double(n2.position.z)
				}
				if let n3 = nodes[allNames[2]]{
					dataPoint.x3 = Double(n3.position.x)
					dataPoint.y3 = Double(n3.position.y)
					dataPoint.z3 = Double(n3.position.z)
				}
				
				try realm.write{
					session.dataPoints.append(dataPoint)
				}
				
			}catch{
				NSLog("Error saving: \(error)")
			}
		}else{
			NSLog("Error in Vuforia VC. Missing Profile ID or session ID, cannot save data")
		}
		//session.addData(coordinate data, timestamp)
		
		
		let currentTime = CFAbsoluteTimeGetCurrent() - time!
		swiftRenderer.render(atTime: currentTime)
		seen = [String]()
	}
	func vuforiaManager(_ manager: VuforiaManager!, didGet context: EAGLContext!) {
		//NOT IN USE
	}
}

extension VuforiaViewController{	//MARK: Drawing Functions
	func drawCylinder(nodeA: SCNNode, nodeB: SCNNode) -> SCNNode{
		let positionStart = nodeA.position
		let positionEnd = nodeB.position
		
		let radius = CGFloat(nodeRadius / 2)
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
	func createProgressBar(width: Double, position: SCNVector3) {
		if(self.progressBarNode != nil) {
			self.progressBarNode?.removeFromParentNode()
		}
		let skScene = SKScene(size: CGSize(width: 180, height: 80))
		skScene.backgroundColor = UIColor.white
		let bar = SKSpriteNode(color:.green,size:CGSize(width: width, height : 160))
		skScene.addChild(bar)
		let plane = SCNPlane(width: 0.1, height: 0.005)
		self.progressBarNode = SCNNode(geometry: plane)
		self.progressBarNode?.position = position
		let material = SCNMaterial()
		material.isDoubleSided = true
		material.diffuse.contents = skScene
		plane.materials = [material]
		//self.scene.rootNode.addChildNode(self.progressBarNode!)
	}
	func drawAngle(between a: SCNNode, b: SCNNode, c: SCNNode, angle: Float){
		var text = ""
		if angle.isNormal{
			text = "\(Int(angle))˚"
		}else{
			text = "NaN"
		}
		let wordNode = SCNNode()
		let myWord = SCNText(string: text, extrusionDepth: CGFloat(0))
		myWord.font = UIFont.systemFont(ofSize: CGFloat(nodeRadius * 2), weight: UIFontWeightBold)
		
		myWord.firstMaterial?.diffuse.contents = UIColor(colorLiteralRed: 51/255, green: 231/255, blue: 242/255, alpha: 1)
		myWord.chamferRadius = CGFloat(nodeRadius / 10.0)
		wordNode.geometry = myWord
		
//		let ap = subtract(a: b.position, b: a.position)
//		let ab = subtract(a: c.position, b: a.position)
//		let apab = dot(a: ap, b: ab)
//		let abab = dot(a: ab, b: ab)
//		let divided = multiply(a: ab, val: apab / abab)
//		let newPoint = add(a: a.position, b: divided)
//		let transform = subtract(a: newPoint, b: b.position)
//		let normTransform = divide(a: transform, val: magnitude(a: transform))
//		
//		let translation = multiply(a: normTransform, val: Float(nodeRadius * 4.0))
//		//move towards norm transform of distance b radius
//		let newPos = add(a: b.position, b: translation)
		
		
		angleNodes[b.name!] = wordNode
		let x = (a.position.x + b.position.x + c.position.x) / 3
		let y = (a.position.y + b.position.y + c.position.y) / 3
		let z = (a.position.z + b.position.z + c.position.z) / 3
		let newPos = SCNVector3Make(x, y, z)
		wordNode.position = newPos
		
		createProgressBar(width: Double(angle/Float(currentSlideVal)) , position: wordNode.position)
		
		let bounds = wordNode.boundingBox.min
		//wordNode.position.x = wordNode.position.x - (bounds.x / 2)
		//wordNode.position.y = wordNode.position.y + (bounds.y / 2)
		
		wordNode.eulerAngles = SCNVector3Make(0, Float.pi, Float.pi/2)
		scene.rootNode.addChildNode(wordNode)
	}
	
	
	func dot(a: SCNVector3, b: SCNVector3) -> Float{
		return (a.x * b.x) + (a.y + b.y) + (a.z + b.z)
	}
	func add(a: SCNVector3, b: SCNVector3) -> SCNVector3{
		return SCNVector3Make(a.x + b.x, a.y + b.y, a.z + b.z)
	}
	func subtract(a: SCNVector3, b: SCNVector3) -> SCNVector3{
		return SCNVector3Make(a.x - b.x, a.y - b.y, a.z - b.z)
	}
	func multiply(a: SCNVector3, val: Float) -> SCNVector3{
		return SCNVector3Make(a.x * val, a.y * val, a.z * val)
	}
	func divide(a: SCNVector3, val: Float) -> SCNVector3{
		return SCNVector3Make(a.x / val, a.y / val, a.z / val)
	}
	
	func magnitude(a: SCNVector3) -> Float{
		let sum = powf(a.x, 2) + powf(a.y, 2) + powf(a.z, 2)
		return sqrt(sum)
	}
}
extension VuforiaViewController: VuforiaEAGLViewSceneSource, VuforiaEAGLViewDelegate {
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
extension VuforiaViewController{	//Physics and Math
	func getAngle(ankle: SCNVector3, knee: SCNVector3, hip: SCNVector3) -> Float {
		let a = pow(knee.x - ankle.x,2) + pow(knee.y-ankle.y,2) + pow(knee.z-ankle.z,2)
		let b = pow(knee.x-hip.x,2) + pow(knee.y-hip.y,2) + pow(knee.z-hip.z,2)
		let c = pow(hip.x-ankle.x,2) + pow(hip.y-ankle.y,2) + pow(hip.z-ankle.z,2)
		
		var division = (360 / (2 * M_PI))
		return (acos( (a+b-c) / sqrt(4*a*b))) * Float(division);
		
	}
    
	func getDepth(ankle: SCNVector3, hip: SCNVector3) -> Float {
		let depth = (hip.y - ankle.y)
		return depth
	}
    
	func getInwards(knee: SCNVector3, hip: SCNVector3) -> Float {
		let difference = (hip.z - knee.z)
		return difference
	}
}

extension VuforiaViewController {
	func didRecieveWillResignActiveNotification(_ notification: Notification) {
		pause()
	}
	func didRecieveDidBecomeActiveNotification(_ notification: Notification) {
		resume()
	}
}

extension VuforiaViewController: MFMailComposeViewControllerDelegate{
	func exportAllSessions(for profileID: String){
		guard MFMailComposeViewController.canSendMail() else{
			NSLog("Cannot export data, unable to send data")
			return
		}
		do{
			let realm = try Realm()
			guard let profile = realm.object(ofType: Profile.self, forPrimaryKey: profileID) else{
				NSLog("Error exporting profile sessions, can't find profile")
				return
			}
			
			let emailController = MFMailComposeViewController()
			emailController.mailComposeDelegate = self
			emailController.setToRecipients([]) //I usually leave this blank unless it's a "message the developer" type thing
			emailController.setSubject("Subject \(profile.subjectNumber) All Session Data")
			emailController.setMessageBody("Data Attached", isHTML: false)
			
			for session in profile.sessions{
				guard session.startTime != nil else{
					NSLog("Error exporting session, start time nil")
					continue
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
					continue
				}
				df.dateStyle = .short
				df.timeStyle = .short
				let fileName = "\(session.owner!.subjectNumber)_\(df.string(from: session.startTime)).csv"
				emailController.addAttachmentData(data, mimeType: "text/csv", fileName: fileName)

			}
			present(emailController, animated: true, completion: nil)
		}catch{
			NSLog("Error exporting data, can't open realm: \(error)")
		}
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
    
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		controller.dismiss(animated: true, completion: nil)
	}
}

