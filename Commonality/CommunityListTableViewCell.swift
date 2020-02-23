//
//  CommunityListTableViewCell.swift
//  Commonality
//
//  Created by Chris Rodriguez on 2/23/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class CommunityListTableViewCell: UITableViewCell {

    @IBOutlet weak var colorCircleView: UIView!
    @IBOutlet weak var communityTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
