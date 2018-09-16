//
//  ForecastCell.swift
//  GetTheWeather
//
//  Created by Phuong Ngo on 9/16/18.
//  Copyright © 2018 Phuong Ngo. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet var icon1: UIImageView!
    @IBOutlet var icon2: UIImageView!
    @IBOutlet var icon3: UIImageView!
    @IBOutlet var icon4: UIImageView!
    
    @IBOutlet var temp1: UILabel!
    @IBOutlet var temp2: UILabel!
    @IBOutlet var temp3: UILabel!
    @IBOutlet var temp4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
