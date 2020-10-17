//
//  MyNotesCellTableViewCell.swift
//  ArNoteThesisIOS
//
//  Created by Gergo on 2020. 10. 17..
//

import UIKit

class MyNotesCellTableViewCell: UITableViewCell {

    @IBOutlet var background: UIView!
    @IBOutlet var shortcode: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var textMessage: UILabel!
    
    @IBOutlet var shortcodeTitle: UILabel!
    @IBOutlet var typeTitle: UILabel!
    @IBOutlet var dateTitle: UILabel!
    @IBOutlet var textTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
