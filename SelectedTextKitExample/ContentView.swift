//
//  ContentView.swift
//  SelectedTextKitExample
//
//  Created by tisfeng on 2024/10/25.
//

import SelectedTextKit
import SwiftUI

struct ContentView: View {
    @State var selectedText = ""

    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Text("Select the following text, and click the button to get the selected text")
                .font(.title2)
                .foregroundStyle(.pink)

            Text(
                """
                Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.
                """
            )
            .textSelection(.enabled)

            Button("Get selected text") {
                Task {
                    selectedText = try await getSelectedTextByMenuBarActionCopy() ?? ""
                }
            }
            
            Text(selectedText)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
