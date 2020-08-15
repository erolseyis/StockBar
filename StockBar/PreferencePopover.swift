//
//  PreferencePopover.swift
//  StockBar
//
//  Created by Hongliang Fan on 2020-06-20.

import Cocoa
import SwiftUI

class PreferencePopover: NSPopover {
    init(data: DataModel) {
        super.init()
        self.behavior = NSPopover.Behavior.transient
        self.contentViewController = PreferenceHostingController(data: data)
        self.contentSize = CGSize(width: 400, height: 400)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
