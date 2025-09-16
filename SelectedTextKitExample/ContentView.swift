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
    @State var selectedStrategy: TextStrategy = .auto
    @State var isLoading = false
    @State var errorMessage = ""
    
    @State var textEditorContent: String = ""
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("SelectedTextKit Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(
                "Select the following text, choose a strategy, and click the button to get the selected text"
            )
            .font(.title2)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            
            Text(
                """
                Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.
                """
            )
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .modifier(TextSelectionModifier())
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            
            VStack(spacing: 20) {
                Text("Text Retrieval Strategy:")
                    .font(.headline)
                
                Picker("Strategy", selection: $selectedStrategy) {
                    ForEach(TextStrategy.allCases, id: \.self) { strategy in
                        Text(strategy.description)
                            .tag(strategy)
                    }
                }
                .pickerStyle(.automatic)
                
                Button(action: getSelectedText) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(isLoading ? "Getting text..." : "Get Selected Text")
                            .fontWeight(.bold)
                            .padding()
                    }
                }
                .foregroundColor(.blue)
                .disabled(isLoading)
            }
            
            VStack(spacing: 10) {
                Text("Selected Text:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(selectedText)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                if !errorMessage.isEmpty {
                    Text("Error:")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text(errorMessage)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.red)
                }
            }
            
            VStack(spacing: 20) {
                Text("Paste the selected text here, focus first")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Button(action: {
                    pasteText(selectedText)
                }) {
                    Text("Paste Selected Text")
                        .fontWeight(.bold)
                        .padding()
                }
                .foregroundColor(.blue)
                
                TextEditor(text: $textEditorContent)
                    .focused($isTextEditorFocused)
                    .frame(height: 100)
                    .padding(10)
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5).stroke(
                            Color(NSColor.separatorColor), lineWidth: 1))
            }
            
            Spacer()
        }
        .padding()
    }
    
    /// Get selected text based on the chosen strategy
    private func getSelectedText() {
        Task {
            isLoading = true
            errorMessage = ""
            selectedText = ""

            do {
                let text = try await SelectedTextManager.shared.getSelectedText(strategy: selectedStrategy)
                selectedText = text ?? "No text selected"
            } catch {
                errorMessage = "Failed to get selected text: \(error.localizedDescription)"
            }
            
            isLoading = false
            
            if let selectedTextFrame = try? AXManager.shared.getSelectedTextFrame() {
                logInfo("Selected text frame: \(selectedTextFrame.rectValue)" )
            }
        }
    }
    
    /// Paste text to the frontmost application
    private func pasteText(_ text: String) {
        isTextEditorFocused = true
        Task {
            await PasteboardManager.shared.pasteText(text, restorePasteboard: true)
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - Helper ViewModifiers

struct TextSelectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 12.0, *) {
            content.textSelection(.enabled)
        } else {
            content
        }
    }
}

