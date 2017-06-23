//
//  ItemShowTeamTableViewCell.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit

class ItemShowTeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var countSum: UILabel!
    
    @IBOutlet weak var country: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(currentFeeds: CurrentShowTeams) {
        self.teamName.text = currentFeeds.countryName
        self.countSum.text = String(currentFeeds.countSum)
        self.country.text = currentFeeds.teamName
        
        self.countSum.isHidden = true
        self.country.isHidden = true
    }

}
