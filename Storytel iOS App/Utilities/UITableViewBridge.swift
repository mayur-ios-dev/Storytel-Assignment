//
//  UITableViewBridge.swift
//  StorytelWatch Watch App
//
//  Created by Mayur Deshmukh on 2022-09-24.
//

import Foundation
import UIKit

protocol UITableViewBridgeDelegate: AnyObject {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    
    func numberOfSections(in tableView: UITableView) -> Int
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

final class UITableViewBridge: NSObject {
    weak var delegate: UITableViewBridgeDelegate?
}

// MARK: - UITableViewDelegate
extension UITableViewBridge: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        delegate?.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension UITableViewBridge: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        delegate?.numberOfSections(in: tableView) ?? 0
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        delegate?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        delegate?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}
