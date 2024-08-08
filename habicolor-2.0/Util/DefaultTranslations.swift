//
//  DefaultTranslations.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/12/2023.
//

import Foundation

enum DefaultTranslations: String {
    case defaultDismissButton = "default_button_dismiss_ok"
    case defaultLoadingLabel = "default_loading_title_label"
    case defaultCloseLabel = "default_close_title_label"
    case defaultAddLabel = "default_add_title_label"
}

extension String {
    
    static func transStandards(for defaultTranslation: DefaultTranslations) -> Self {
        trans(defaultTranslation.rawValue)
    }
}
