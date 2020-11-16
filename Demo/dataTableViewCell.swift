//
//  dataTableViewCell.swift
//  Demo
//
//  Created by Santhosh on 11/11/20.
//  Copyright © 2020 CodeinSwift. All rights reserved.
//

import UIKit

class dataTableViewCell: UITableViewCell {

    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
