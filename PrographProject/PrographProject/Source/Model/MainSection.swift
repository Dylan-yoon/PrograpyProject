//
//  MainSection.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/1/24.
//

enum MainSection: Int, Hashable, CaseIterable, CustomStringConvertible {
    case bookmark, recents
    
    var description: String {
        switch self {
        case .bookmark: return "Recents"
        case .recents: return "Outline"
        }
    }
}
