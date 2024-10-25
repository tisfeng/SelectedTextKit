//
//  ContentView.swift
//  SelectedTextKitExample
//
//  Created by tisfeng on 2024/10/25.
//

import SwiftUI
import SelectedTextKit

struct ContentView: View {
    @State var selectedText = ""

    var body: some View {
        VStack {
            Text("Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.")
                .textSelection(.enabled)
            Button("Get selected text") {
                selectedText = SystemUtility.getSelectedText() ?? ""
            }
            Text(selectedText)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
