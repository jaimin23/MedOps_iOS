//
//  AdminTableViewCell.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-12-07.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class AdminTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setAdminInfo(user: User){
        let userType = getUserTypeValue(type: user.userType!)
        if (user.userType != 0){
            self.userNameLbl.text = user.firstName
            self.userTypeLbl.text = userType
        }
    }

}
