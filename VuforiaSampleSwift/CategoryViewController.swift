//
//  CategoryViewController.swift
//  PennApps_Bomo
//
//  Created by Antonio on 9/9/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit
import Foundation




class CategoryViewController: UIViewController {
	@IBOutlet weak var squatButton: UIButton!
	@IBOutlet weak var jumpButton: UIButton!
	@IBOutlet weak var lungeButton: UIButton!
	@IBOutlet weak var abButton: UIButton!
	@IBOutlet weak var bikeButton: UIButton!
	@IBOutlet weak var cleanButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.squatButton.alpha = 0
		self.jumpButton.alpha = 0
		self.lungeButton.alpha = 0
		self.abButton.alpha = 0
		self.bikeButton.alpha = 0
		self.cleanButton.alpha = 0
		
 }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
		UIView.animate(withDuration: 0.5, animations: {
			self.squatButton.alpha = 1.0
		})
		UIView.animate(withDuration: 0.6, animations: {
			self.jumpButton.alpha = 1.0
		})
		UIView.animate(withDuration: 0.7, animations: {
			self.lungeButton.alpha = 1.0
		})
		UIView.animate(withDuration: 0.8, animations: {
			self.abButton.alpha = 1.0
		})
		UIView.animate(withDuration: 0.9, animations: {
			self.bikeButton.alpha = 1.0
		})
		UIView.animate(withDuration: 1.0, animations: {
			self.cleanButton.alpha = 1.0
		})
		
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	
}
