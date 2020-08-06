//
//  StockMenuBarController.swift
//  StockBar
//
//  Created by Hongliang Fan on 2020-06-20.

import Foundation
import Combine
import Cocoa


class StockMenuBarController {
    init () {
        constructMainItem()
        updateTickerItemsFromPrefs()
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fetchAllQuote),                                                                              userInfo: nil, repeats: true)
    }
    private var cancellables : AnyCancellable?
    private let statusBar = StockStatusBar()

    private let userData = UserData.sharedInstance
    //private lazy var prefs = Preferences()
    private lazy var timer = Timer()
    private lazy var prefPopover = PreferencePopover()
    private lazy var mainMenuItems = [NSMenuItem(title: "Refresh", action: #selector(fetchAllQuote), keyEquivalent: ""),
                                      NSMenuItem.separator(),
                                      NSMenuItem(title: "Preference", action: #selector(togglePopover), keyEquivalent: ""),
                                      NSMenuItem(title:  "Exit", action: #selector(quitApp), keyEquivalent: "q")]
}

extension StockMenuBarController {
    func constructMainItem() {
        for item in mainMenuItems {
            item.target = self
        }
        self.statusBar.constructMainItemMenu(items: mainMenuItems)
    }
    private func updateTickerItemsFromPrefs() {
        statusBar.removeAllTickerItems()
        for iter in (0..<userData.realTimeTrades.count) {
            statusBar.constructTickerItems(realTimeTrade: userData.realTimeTrades[iter])
        }
//        for id in prefs.nonEmptyTickers() {
//            statusBar.constructTickerItems(tickerId: id)
//        }
        fetchAllQuote()
    }

    @objc private func fetchAllQuote() {
        for realTimeTrade in self.userData.realTimeTrades {
            realTimeTrade.sendTradeToPublisher()
        }
    }
    @objc private func quitApp() {
        NSApp.terminate(self)
    }
    
    @objc func togglePopover(_ sender: Any?) {
        showPopover(sender: sender)
    }

    func showPopover(sender: Any?) {
        if let button = self.statusBar.mainItem()?.button {
            prefPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
