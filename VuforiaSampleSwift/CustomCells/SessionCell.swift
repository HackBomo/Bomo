//
//  SessionCell.swift
//  VuforiaSampleSwift
//
//  Created by Tyler Angert on 10/18/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import UIKit

class SessionCell: UITableViewCell {
    
    // MARK: Realm references
    var sessionID: String?
    
    // MARK: IBOutlets
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var exportButton: UIButton!
    
    override func awakeFromNib() {
        
    }
    
    // MARK: IBActions

    @IBAction func exportPressed(_ sender: Any) {
    }
    
}
