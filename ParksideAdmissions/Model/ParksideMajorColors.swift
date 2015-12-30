//
//  ParksideMajorColors.swift
//  Parkside Admissions
//
//  Created by Kyle Zawacki on 12/29/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//
//  This file is used for the inflating bubble transition.

import UIKit
import UIColor_Hex_Swift

enum MajorColors {
    case FirstColor
    case SecondColor
    case ThirdColor
    case FourthColor
    case FithColor
    
    func uiColor() -> UIColor {
        switch self {
            case .FirstColor:
                return UIColor(rgba: "#016836")
            case .SecondColor:
                return UIColor(rgba: "#9D162E")
            case .ThirdColor:
                    return UIColor(rgba: "#72A84F")
            case .FourthColor:
                return UIColor(rgba: "#C9602C")
            case .FithColor:
                return UIColor(rgba: "#003A5C")
        }
    }
}

class GetColors {
    static func getList() -> [UIColor] {
        return [MajorColors.FirstColor.uiColor(), MajorColors.SecondColor.uiColor(),
            MajorColors.ThirdColor.uiColor(), MajorColors.FourthColor.uiColor(),
            MajorColors.FithColor.uiColor()]
    }
}