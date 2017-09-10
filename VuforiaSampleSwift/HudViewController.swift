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
	func startSessionPressed()
	func endSessionPressed()
	func startSetPressed()
	func endSetPressed()
	func sliderDidChange(value: Int)
	func didDismiss()
}

class HudViewController: UIViewController{
	
	var delegate: HudViewDelegate?
	@IBOutlet weak var startSetButton: UIButton!
	@IBOutlet weak var endSetButton: UIButton!
	@IBOutlet weak var startSessionButton: UIButton!
	@IBOutlet weak var endSessionButton: UIButton!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var goalLabel: UILabel!
	
	var currentSlideVal = 90
	
	@IBOutlet weak var realtimeLineChart: LineChartView!
	@IBOutlet weak var popupView: UIView!
	
	
	var lineChartEntry = [ChartDataEntry]()
	var currentTime: Double = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepRealtimeData()
	}
	override func viewDidAppear(_ animated: Bool) {
		UIView.animate(withDuration: 0.3) { 
			self.popupView.alpha = 0.9
		}
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
	
	
	@IBAction func sliderChanged(_ sender: Any) {
		var val = (sender as! UISlider).value
		self.currentSlideVal = Int(val)
		self.delegate?.sliderDidChange(value: currentSlideVal)
		self.goalLabel.text = "Goal flexion: \(self.currentSlideVal)"
	}
	
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
		endSetButton.isHidden = true
		startSetButton.isHidden = false
		print("end set pressed")
		delegate?.endSetPressed()
	}
	
	@IBAction func closePressed(){
		UIView.animate(withDuration: 0.3) { 
			self.popupView.alpha = 0
		}
	}
	@IBAction func backPressed(){
		performSegue(withIdentifier: "doubleUnwind", sender: self)
	}
	
}

extension HudViewController: MainVCDelegate {
	func didCalculateAngle(angle: Float) {
		//print("got: \(angle)")
	
		
		//take in a new entry as a parameter from the ARManager
		let newEntry = ChartDataEntry(x: currentTime, y: Double(angle))
		self.realtimeLineChart.data?.addEntry(newEntry, dataSetIndex: 0)
		
		//scrolls the view if larger than 100 points
		if((self.realtimeLineChart.data?.entryCount)! > 50) {
			self.realtimeLineChart.data?.removeEntry(xValue: 0, dataSetIndex: 0)
		}
		
		//        print("changing dataset!")
		self.realtimeLineChart.notifyDataSetChanged()
		
		currentTime+=1
		
	}
}
