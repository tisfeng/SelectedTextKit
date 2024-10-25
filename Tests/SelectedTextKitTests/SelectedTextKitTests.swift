import Foundation
import Testing

@testable import SelectedTextKit

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func getSelectedText() {
    Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
        if let text = SystemUtility.getSelectedText() {
            print("getSelectedText: \(text)")
        }
    }
    RunLoop.current.run()
}
