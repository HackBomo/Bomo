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
    
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var goalButton: UIButton!
    
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
		// Do any additional setup after loading the view.
        scrollView.contentSize.height = 900
        
        
	}

    @IBAction func pastTapped(_ sender: Any) {
        pastButton.setImage(#imageLiteral(resourceName: "Past_Bright"), for: .normal)
        todayButton.setImage(#imageLiteral(resourceName: "Today_Dark"), for: .normal)
        goalButton.setImage(#imageLiteral(resourceName: "Goal_Dark"), for: .normal)
        
    }
    
    @IBAction func todayTapped(_ sender: Any) {
        pastButton.setImage(#imageLiteral(resourceName: "Past_Dark"), for: .normal)
        todayButton.setImage(#imageLiteral(resourceName: "Today_Bright"), for: .normal)
        goalButton.setImage(#imageLiteral(resourceName: "Goal_Dark"), for: .normal)
        
    }
    
    @IBAction func goalTapped(_ sender: Any) {
        pastButton.setImage(#imageLiteral(resourceName: "Past_Dark"), for: .normal)
        todayButton.setImage(#imageLiteral(resourceName: "Today_Dark"), for: .normal)
        goalButton.setImage(#imageLiteral(resourceName: "Goal_Bright"), for: .normal)
    }

	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
	
}
