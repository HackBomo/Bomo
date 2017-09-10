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
    
    
    @IBOutlet weak var depthButton: UIButton!
    @IBOutlet weak var velocityButton: UIButton!
    @IBOutlet weak var powerButton: UIButton!
    
    @IBOutlet weak var graphImage: UIImageView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
		// Do any additional setup after loading the view.
        scrollView.contentSize.height = 900
        
	}
    
    
    @IBAction func depthTapped(_ sender: Any) {
        depthButton.setImage(#imageLiteral(resourceName: "depth-selected"), for: .normal)
        velocityButton.setImage(#imageLiteral(resourceName: "velocity-deselected"), for: .normal)
        powerButton.setImage(#imageLiteral(resourceName: "power-deselected"), for: .normal)
        graphImage.image = UIImage(named: "Graph 1")
    }
    
 
    
    @IBAction func velocityTapped(_ sender: Any) {
        depthButton.setImage(#imageLiteral(resourceName: "depth-deselected"), for: .normal)
        velocityButton.setImage(#imageLiteral(resourceName: "velocity-selected"), for: .normal)
        powerButton.setImage(#imageLiteral(resourceName: "power-deselected"), for: .normal)
        graphImage.image = UIImage(named: "Graph 2")
    }
    
    @IBAction func powerTapped(_ sender: Any) {
        depthButton.setImage(#imageLiteral(resourceName: "depth-deselected"), for: .normal)
        velocityButton.setImage(#imageLiteral(resourceName: "velocity-deselected"), for: .normal)
        powerButton.setImage(#imageLiteral(resourceName: "power-selected"), for: .normal)
        graphImage.image = UIImage(named: "Graph 3")
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
