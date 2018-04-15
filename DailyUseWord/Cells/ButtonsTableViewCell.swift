//
//  ButtonsTableViewCell.swift
//  DailyUseWord
//
//  Created by Muhammad Burhan on 09/12/2017.
//  Copyright © 2017 Burhan Mughal. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
