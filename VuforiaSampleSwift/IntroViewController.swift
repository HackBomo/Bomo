//
//  IntroViewController .swift
//  PennApps_Bomo
//
//  Created by Antonio on 9/8/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
	
	@IBOutlet weak var mainScrollView: UIScrollView!
	
	var imageArray = [UIImage]()
	var backgroundArray = [UIImage]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mainScrollView.frame = view.frame
		imageArray = [#imageLiteral(resourceName: "Swipe 1"), #imageLiteral(resourceName: "Swipe 2"), #imageLiteral(resourceName: "Swipe 3")]
		
		for i in 0..<imageArray.count {
			
			let imageView = UIImageView()
			
			
			imageView.image = imageArray[i]
			
			
			imageView.contentMode = .scaleAspectFill
			
			mainScrollView.contentOffset.x = view.frame.width / 1.25
			
			let xPosition = (self.view.frame.width / 1.25 ) * CGFloat(i)
			imageView.frame = CGRect(x: xPosition + (self.view.frame.width/4), y: self.view.frame.height/3.75, width: self.mainScrollView.frame.width/2, height: self.mainScrollView.frame.height/2)
			
			
			mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(Double(i) + 0.60)
			mainScrollView.addSubview(imageView)
		}
		
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
}
