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
        TemplateModel(name: trans("add_habit_view_template_option_0"), color: .yellow),
        TemplateModel(name: trans("add_habit_view_template_option_1"), color: .green),
        TemplateModel(name: trans("add_habit_view_template_option_2"), color: .purple),
        TemplateModel(name: trans("add_habit_view_template_option_3"), color: .redColor),
        TemplateModel(name: trans("add_habit_view_template_option_4"), color: .blue),
    ]
    
}
