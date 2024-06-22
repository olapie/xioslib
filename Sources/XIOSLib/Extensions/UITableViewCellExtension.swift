//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit

extension UITableViewCell {
    func tableView() -> UITableView? {
        var v: UIView? = self
        while v != nil {
            if let t = v as? UITableView {
                return t
            }
            v = v?.superview
        }
        return nil
    }
}
