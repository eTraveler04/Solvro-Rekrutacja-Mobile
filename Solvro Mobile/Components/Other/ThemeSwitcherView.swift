//
//  ThemeSwutcherView.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 18/03/2025.
//

import SwiftUI

struct ThemeSwitcherView: View {
    // Binding do globalnej zmiennej trybu ciemnego
    @Binding var isDarkMode: Bool

    var body: some View {
        VStack(spacing: 20) {
            // Toggle do przełączania trybu ciemnego
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        // CHANGE: Make background transparent instead of using Color("Background")
        .background(Color.clear)
    }
}

struct ThemeSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        // W podglądzie tworzymy tymczasowy binding dla przykładu.
        ThemeSwitcherView(isDarkMode: .constant(false))
    }
}
