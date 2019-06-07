//
//  CheckListItem.swift
//  Checklists
//
//  Created by demas on 06/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import Foundation

class CheckListItem : NSObject {
    var text = ""
    var checked = false

    func toggleChecked() {
        checked = !checked
    }
}

