//
//  SearchBarView.swift
//  CycloStats
//
//  Created by Theo Sementa on 20/05/2025.
//


import SwiftUI
import TheoKit

struct SearchBarView: View {
    
    // MARK: Dependencies
    var placeholder: String
    @Binding var searchText: String
        
    @FocusState private var isFocused: Bool
    
    // MARK: init
    init(_ placeholder: String, searchText: Binding<String>) {
        self.placeholder = placeholder
        self._searchText = searchText
    }
    
    var isSearching: Bool {
        return !searchText.isEmpty
    }
    
    // MARK: - View
    var body: some View {
        HStack(spacing: 8) {
            Image(.iconSearch)
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(isSearching ? Color.appGreen : TKDesignSystem.Colors.Background.Theme.bg500)
            
            TextField(placeholder, text: $searchText)
                .focused($isFocused)
                .fontWithLineHeight(Fonts.Body.medium)
                .foregroundStyle(Color.label)
                .toolbar {
                    ToolbarDismissKeyboardButtonView()
                }
            
            if isSearching {
                Button {
                    searchText = ""
                } label: {
                    Image(.iconCircleXmark)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.label)
                }
            }
        }
        .padding(TKDesignSystem.Padding.regular)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.small,
        )
        .onTapGesture {
            isFocused = true
        }
    }
}

// MARK: - Preview
#Preview {
    SearchBarView("kn", searchText: .constant("kn"))
        .padding()
        .background(Color.blue)
}
