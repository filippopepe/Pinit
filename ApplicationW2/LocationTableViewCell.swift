//
//  LocationTableViewCell.swift
//  ApplicationW2
//
//  Created by Vincenzo Cimmino on 27/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLocation: UILabel!
    @IBOutlet weak var nameLocation: UILabel!
    @IBOutlet weak var imageLocation: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
