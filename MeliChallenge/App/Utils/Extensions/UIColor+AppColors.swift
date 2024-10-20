//
//  UIColor+AppColors.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

extension UIColor {
    private static func color(named name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("\(name) \("no_defined_assets".localized)")
        }
        return color
    }

    static let mainColor = UIColor.color(named: "mainColor")
    static let secondaryColor = UIColor.color(named: "secondaryColor")
    static let secondaryTextColor = UIColor.color(named: "secondaryTextColor")
}
