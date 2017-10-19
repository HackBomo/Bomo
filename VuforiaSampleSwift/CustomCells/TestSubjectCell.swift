//
//  TestSubjectCell.swift
//  VuforiaSampleSwift
//
//  Created by Tyler Angert on 10/18/17.
//  Copyright © 2017 Yoshihiro Kato. All rights reserved.
//

import Foundation
import UIKit

class TestSubjectCell: UITableViewCell {
    
    // MARK: Realm references
    var testSubjectID: String?

    // MARK: IBOutlets
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var sessionsLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
}
