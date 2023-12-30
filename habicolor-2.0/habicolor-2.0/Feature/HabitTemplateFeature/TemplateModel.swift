//
//  TemplateModel.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/12/2023.
//

import Foundation
import SwiftUI

struct TemplateModel: Hashable {
    var name: String
    var color: Color
}

extension TemplateModel {
    
    static var templates: [TemplateModel] = [
        TemplateModel(name: "🧘🏼 Meditate", color: .yellow),
        TemplateModel(name: "⭐️ Learn a new skill", color: .green),
        TemplateModel(name: "🚶‍♂️ Step count", color: .purple),
        TemplateModel(name: "🏋️ Workout", color: .redColor),
        TemplateModel(name: "🛏️ Go to bed early", color: .blue),
    ]
    
}
