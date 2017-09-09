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
	var arManager: ARManager?
	
	var objects = [String: SCNNode?]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
		arManager?.stop()
		/*do {
		try vuforiaManager?.stop()
		}catch let error {
		print("\(error)")
		}*/
	}
}

private extension ViewController {
	func prepare() {
		arManager = ARManager(licenseKey: vuforiaLicenseKey, dataPath: vuforiaDataSetFile)
		guard arManager != nil else{
			print("Error, AR Manager is nil")
			return
		}
		arManager?.delegate = self
		
		vuforiaManager = VuforiaManager(licenseKey: vuforiaLicenseKey, dataSetFile: vuforiaDataSetFile)
		//if let manager = vuforiaManager {
		// manager.delegate = self
		//    manager.eaglView.sceneSource = self
		//manager.eaglView.delegate = self
		//manager.eaglView.setupRenderer()
		//self.view = manager.eaglView
		//}
		
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
		print("looking at \(state.numberOfTrackableResults) trackables")
		
		for index in 0 ..< state.numberOfTrackableResults {
			guard let result = state.trackableResult(at: index) else{
				continue
			}
			let name = result.trackable.name!
			guard objects[name] == nil else{	//skip recognized objects
				continue
			}
			
			print("number of trackables: \(state.numberOfTrackableResults)")
			
			//create new scnnodes
			let circle = SCNNode(geometry: SCNSphere(radius: 1))
			let renderer: SCNRenderer = manager.eaglView.getRenderer()
			renderer.scene?.rootNode.addChildNode(circle)
			print("adding node on \(name)")
			objects[name] = circle
			
			//let trackerableName = result?.trackable.name
			/*if trackerableName == "stones" {
			boxMaterial.diffuse.contents = UIColor.red
			
			if lastSceneName != "stones" {
			manager.eaglView.setNeedsChangeSceneWithUserInfo(["scene" : "stones"])
			lastSceneName = "stones"
			}
			}else {
			boxMaterial.diffuse.contents = UIColor.blue
			
			if lastSceneName != "chips" {
			manager.eaglView.setNeedsChangeSceneWithUserInfo(["scene" : "chips"])
			lastSceneName = "chips"
			}
			}*/
			
		}
	}
}

extension ViewController: VuforiaEAGLViewSceneSource, VuforiaEAGLViewDelegate {
	
	func scene(for view: VuforiaEAGLView!, userInfo: [String : Any]?) -> SCNScene! {
		
		print("creating a new scene")
		let scene = SCNScene()
		
		
		let lightNode = SCNNode()
		lightNode.light = SCNLight()
		lightNode.light?.type = .omni
		lightNode.light?.color = UIColor.lightGray
		lightNode.position = SCNVector3(x:0, y:10, z:10)
		scene.rootNode.addChildNode(lightNode)
		
		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light?.type = .ambient
		ambientLightNode.light?.color = UIColor.darkGray
		scene.rootNode.addChildNode(ambientLightNode)
		
		let planeNode = SCNNode()
		planeNode.name = "plane"
		planeNode.geometry = SCNPlane(width: 247.0*view.objectScale, height: 173.0*view.objectScale)
		planeNode.position = SCNVector3Make(0, 0, -1)
		let planeMaterial = SCNMaterial()
		planeMaterial.diffuse.contents = UIColor.green
		planeMaterial.transparency = 0.6
		planeNode.geometry?.firstMaterial = planeMaterial
		scene.rootNode.addChildNode(planeNode)
		
		let boxNode = SCNNode()
		boxNode.name = "box"
		boxNode.geometry = SCNBox(width:1, height:1, length:1, chamferRadius:0.0)
		scene.rootNode.addChildNode(boxNode)
		
		let circle = SCNNode()
		circle.geometry = SCNSphere(radius: 2)
		scene.rootNode.addChildNode(circle)
		
		return scene
		
	}
	/*fileprivate func createChipsScene(with view: VuforiaEAGLView) -> SCNScene {
	let scene = SCNScene()
	
	boxMaterial.diffuse.contents = UIColor.lightGray
	
	let lightNode = SCNNode()
	lightNode.light = SCNLight()
	lightNode.light?.type = .omni
	lightNode.light?.color = UIColor.lightGray
	lightNode.position = SCNVector3(x:0, y:10, z:10)
	scene.rootNode.addChildNode(lightNode)
	
	let ambientLightNode = SCNNode()
	ambientLightNode.light = SCNLight()
	ambientLightNode.light?.type = .ambient
	ambientLightNode.light?.color = UIColor.darkGray
	scene.rootNode.addChildNode(ambientLightNode)
	
	let planeNode = SCNNode()
	planeNode.name = "plane"
	planeNode.geometry = SCNPlane(width: 247.0*view.objectScale, height: 173.0*view.objectScale)
	planeNode.position = SCNVector3Make(0, 0, -1)
	let planeMaterial = SCNMaterial()
	planeMaterial.diffuse.contents = UIColor.red
	planeMaterial.transparency = 0.6
	planeNode.geometry?.firstMaterial = planeMaterial
	scene.rootNode.addChildNode(planeNode)
	
	let boxNode = SCNNode()
	boxNode.name = "box"
	boxNode.geometry = SCNBox(width:1, height:1, length:1, chamferRadius:0.0)
	boxNode.geometry?.firstMaterial = boxMaterial
	scene.rootNode.addChildNode(boxNode)
	
	return scene
	}*/
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

extension ViewController: ARManagerDelegate{
	
}

