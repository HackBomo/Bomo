//
//  SquatPop.swift
//  PennApps_Bomo
//
//  Created by Antonio on 9/9/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

protocol popupDelegate {
	func popupDidClose()
}

class JumpPop: UIViewController {
	
	@IBOutlet weak var popupView: UIView!
	
	var delegate: popupDelegate?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		popupView.layer.cornerRadius = 10
		popupView.layer.masksToBounds = true
		popupView?.backgroundColor = UIColor(white: 1, alpha: 0)
		self.view.backgroundColor = UIColor(white: 0.3, alpha: 0)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 0.5, animations: {
			self.popupView.alpha = 0.9
		})
	}
	
	@IBAction func closePopup(_ sender: Any) {
		delegate?.popupDidClose()
		dismiss()
	}
	
	func dismiss()
	{
		willMove(toParentViewController: nil)
		view.removeFromSuperview()
		removeFromParentViewController()
	}
	
	
	
	
	
}

