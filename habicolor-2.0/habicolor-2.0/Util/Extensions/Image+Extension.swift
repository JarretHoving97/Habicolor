
//  Image+Extension.swift
//  Habicolor
//
//  Created by Jarret Hoving on 06/11/2022.
//

import SwiftUI

extension Image {
    
    struct Icons {
        static let cancelIcon = Image("cancel_icon")
        static let checkmarkIcon = Image("check_icon")
        static let heartIcon = Image(systemName: "heart.fill")
        static let check = Image("default_checkmark")
        static let plus = Image("plus")
        static let notificationOn = Image(systemName: "bell.fill")
        static let notificationOff = Image(systemName: "bell.slash.fill")
        
        static func notificationIcon(on: Bool) -> Image {
            
            let notificationOn = Image(systemName: "bell")
            let notificationoff = Image(systemName: "bell.slash")
            
            let image = on ? notificationOn : notificationoff
        
            return  image.renderingMode(.template)
        }
    }
    
}
