//
//  VitalSignsService.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 17/01/2024.
//

import Foundation
import ComposableArchitecture

struct Bpm: Equatable {
    let data: String
    let date: Date
}

protocol CurrentHearthBPMReadable {

    func read() async throws -> Bpm
}

