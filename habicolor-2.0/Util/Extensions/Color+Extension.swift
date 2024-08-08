//
//  Color+Extension.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 14/10/2023.
//

import UIKit
import SwiftUI


extension Color {
 
    static let appBackgroundColor = Color(uiColor: UIColor(named: "app_background_color")!)
    
    static let appTextColor = Color(uiColor: UIColor(named: "app_text_color")!)
    
    static let cardColor = Color(uiColor:  UIColor(named: "card_background_color")!)
    
    static let primaryColor = Color(uiColor: UIColor(named: "primary_color")!)
    
    static let secondaryColor = Color(uiColor: UIColor(named: "secondary_color")!)
    
    static let justWhite = Color(uiColor: UIColor(named: "full_white")!)
    
    static let pixelEmptyColor = Color(uiColor: UIColor(named: "pixel_unselected_color")!)
    
    static let emptyColor = Color(hex: "#EEEEEE")
    
    static let redColor = Color(uiColor: UIColor(named: "red_color")!)
    static let shadowColor = Color("shadow")
    
    struct Notify {
        
        static let normal = Color(UIColor(named: "normal")!)
        
        static let destructive = Color(UIColor(named: "destructive")!)
        
        static let accept = Color(UIColor(named: "accept")!)
    
    }
    
}
