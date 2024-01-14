
//
//  HealthTemplate.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 10/01/2024.
//

import Foundation
import SwiftUI

protocol HealthPresentable: Equatable {
    
    var icon: Image { get }
    
    var title: String { get }
    
    var color: Color { get }
    
    var template: HealthCase { get }
}


