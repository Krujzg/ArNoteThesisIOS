//
//  CustomTableViewCell.swift
//  ArNoteThesisIOS
//
//  Created by Gergo on 2020. 10. 13..
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var shortcode: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
