//
//  ExtendSquatViewController.swift
//  VuforiaSampleSwift
//
//  Created by Antonio on 9/9/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import UIKit

class ExtendSquatViewController: UIViewController {

//IBOutlets

    @IBOutlet weak var squatImage: UIImageView!
    @IBOutlet weak var trainButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.squatImage.alpha = 0
        self.trainButton.alpha = 0
        self.statsButton.alpha = 0

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.squatImage.alpha = 1.0
        })
        UIView.animate(withDuration: 0.6, animations: {
            self.trainButton.alpha = 1.0
        })
        UIView.animate(withDuration: 0.7, animations: {
            self.statsButton.alpha = 1.0
        })

        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    

}
