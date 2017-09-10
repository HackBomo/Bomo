//
//  HudViewController.swift
//  VuforiaSampleSwift
//
//  Created by Jake Cronin on 9/10/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import UIKit

protocol HudViewDelegate {
	func startSessionPressed()
	func endSessionPressed()
	func startSetPressed()
	func endSetPressed()
}

class HudViewController: UIViewController{
	
	var delegate: HudViewDelegate?
	@IBOutlet weak var startSetButton: UIButton!
	@IBOutlet weak var endSetButton: UIButton!
	@IBOutlet weak var startSessionButton: UIButton!
	@IBOutlet weak var endSessionButton: UIButton!
	
	@IBAction func startSessionPressed(sender: AnyObject){
		startSessionButton.isHidden = true
		endSessionButton.isHidden = false
		startSetButton.isHidden = false
		endSetButton.isHidden = true
		print("start session pressed")
		delegate?.startSessionPressed()
		
	}
	@IBAction func endSessionPressed(sender: AnyObject){
		startSessionButton.isHidden = false
		endSessionButton.isHidden = true
		startSetButton.isHidden = true
		endSetButton.isHidden = true
		print("end session pressed")
		delegate?.endSessionPressed()
	}
	@IBAction func startSetPressed(sender: AnyObject){
		endSetButton.isHidden = false
		startSetButton.isHidden = true
		print("start set pressed")
		delegate?.startSetPressed()
	}
	
	@IBAction func endSetPressed(sender: AnyObject){
		endSetButton.isHidden = false
		startSetButton.isHidden = true
		print("end set pressed")
		delegate?.endSetPressed()
	}
	
}
