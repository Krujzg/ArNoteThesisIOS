//
//  MyNote.swift
//  ArNoteThesisIOS
//
//  Created by Gergo on 2020. 10. 13..
//

import Foundation

class MyNote
{
    var shortcode = ""
    var type = ""
    var date = ""
    var textMessage = ""
    init(shortCode : String, type : String, date : String, textMessage : String)
    {
        self.shortcode = shortCode
        self.type = type
        self.date = date
        self.textMessage = textMessage
    }
}
