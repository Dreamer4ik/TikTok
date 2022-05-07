//
//  SwitchCellViewModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 07.05.2022.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
