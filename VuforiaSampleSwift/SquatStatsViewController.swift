//
//  SquatStatsViewController.swift
//  PennApps_Bomo
//
//  Created by Antonio on 9/9/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class SquatStatsViewController: UIViewController {
	
    @IBOutlet weak var scrollView: UIScrollView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
        
        scrollView.contentSize.height = scrollView.frame.height * 1
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
}
