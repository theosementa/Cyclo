//
//  ToolbarDismissKeyboardButtonView.swift
//  CycloStats
//
//  Created by Theo Sementa on 20/05/2025.
//

import SwiftUI

struct ToolbarDismissKeyboardButtonView: ToolbarContent {
        
    // MARK: - View
    var body: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                EmptyView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Image(systemName: "keyboard.chevron.compact.down.fill")
                        .foregroundStyle(Color.appGreen)
                })
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
