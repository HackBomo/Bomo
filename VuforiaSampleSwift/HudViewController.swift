//
//  HudViewController.swift
//  VuforiaSampleSwift
//
//  Created by Jake Cronin on 9/10/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import UIKit
import Charts

protocol HudViewDelegate {
	func didSaveSession()
    func didCancelSession()
	func didDismiss()
}

class HudViewController: UIViewController{
	
	var delegate: HudViewDelegate?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var realtimeLineChart: LineChartView!
	
	
	var lineChartEntry = [ChartDataEntry]()
	var currentTime: Double = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        cancelButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        
		prepRealtimeData()
	}

	func prepRealtimeData(){
		let data = LineChartData()
		let dataset = LineChartDataSet(values: nil, label: nil)
		dataset.colors = [NSUIColor.red]
		data.addDataSet(dataset)
		
		self.realtimeLineChart.data = data
		self.realtimeLineChart.gridBackgroundColor = NSUIColor.white
		self.realtimeLineChart.xAxis.enabled = false
		
		self.realtimeLineChart.rightAxis.enabled = false
		self.realtimeLineChart.legend.enabled = false
		self.realtimeLineChart.backgroundColor = UIColor.clear
		
		self.realtimeLineChart.chartDescription?.text = ""
		
		//Axis size setup
		self.realtimeLineChart.leftAxis.axisMaximum = 180
		self.realtimeLineChart.leftAxis.axisMinimum = 10
		self.realtimeLineChart.leftAxis.drawGridLinesEnabled = false
		self.realtimeLineChart.leftAxis.drawAxisLineEnabled = false
		self.realtimeLineChart.leftAxis.drawLabelsEnabled = false
		
		
		let lineChartSet = self.realtimeLineChart.data?.dataSets[0] as! LineChartDataSet
		lineChartSet.drawValuesEnabled = false
		lineChartSet.circleRadius = 0
		lineChartSet.fillAlpha = 0
		lineChartSet.mode = .cubicBezier
		lineChartSet.lineWidth = 5
		lineChartSet.label = ""
		lineChartSet.drawCirclesEnabled = true
		lineChartSet.drawFilledEnabled = true
		lineChartSet.colors = [UIColor.white]
	}
    
    // MARK: MAIN HUD DELEGATE METHODS
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cancel session", message: "Are you sure you want to cancel?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (alert) in
            self.delegate?.didCancelSession()
			self.performSegue(withIdentifier: "unwindToSubjectDetailVC", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        self.delegate?.didSaveSession()
		performSegue(withIdentifier: "unwindToSubjectDetailVC", sender: self)

    }

	@IBAction func backPressed(){
		performSegue(withIdentifier: "unwindToSubjectDetailVC", sender: self)
	}	
}

extension HudViewController: MainVCDelegate {
	func didCalculateAngle(angle: Float) {
		//print("got: \(angle)")
	
		
		//take in a new entry as a parameter from the ARManager
		let newEntry = ChartDataEntry(x: currentTime, y: Double(angle))
		self.realtimeLineChart.data?.addEntry(newEntry, dataSetIndex: 0)
		
		//scrolls the view if larger than 100 points
		if((self.realtimeLineChart.data?.entryCount)! > 100) {
			self.realtimeLineChart.data?.removeEntry(xValue: 0, dataSetIndex: 0)
		}
		
		//        print("changing dataset!")
		self.realtimeLineChart.notifyDataSetChanged()
		
		currentTime+=1
		
	}
}
