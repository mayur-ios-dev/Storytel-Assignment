//
//  NSLayoutConstraint+Priority.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-23.
//

import UIKit

extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
