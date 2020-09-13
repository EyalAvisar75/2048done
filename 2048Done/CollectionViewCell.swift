//
//  CollectionViewCell.swift
//  My2048
//
//  Created by eyal avisar on 08/09/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pointsLabel: UILabel!
    var cellNumber:Int?
    var cellPoints:Int = 0
    
    func setup(cellNumber:Int) {
        self.cellNumber = cellNumber
        pointsLabel.text = ""
    }
}
