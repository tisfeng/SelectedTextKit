//
//  AsyncTimeout.swift
//  SelectedTextKit
//
//  Created by tisfeng on 2025/9/8.
//

import Foundation

/// Runs an asynchronous operation with a timeout.
///
/// This utility starts both the provided `body` task and a timeout task
/// concurrently. Whichever task completes first determines the result:
/// - If `body` finishes before the timeout, its result is returned.
/// - If the timeout elapses first, a `TimeoutError` is thrown and the other task is cancelled.
///
/// - Parameters:
///   - seconds: The timeout duration in seconds.
///   - isolation: The actor isolation context for running the task. Defaults to the caller's isolation.
///   - body: The asynchronous operation to run.
///
/// - Returns: The result of the `body` closure if it completes before the timeout expires.
///
/// - Throws:
///   - `TimeoutError` if the operation does not complete in the given `timeout`.
///   - Any error thrown by the `body` closure.
///
/// - Example:
/// ```swift
/// do {
///     let result = try await withTimeout(in: 2.0) {
///         try await Task.sleep(for: .seconds(1))
///         return "done"
///     }
///     print(result) // "done"
/// } catch {
///     print("Timeout or error:", error)
/// }
/// ```
///
/// - Note: This implementation uses structured concurrency to provide timeout functionality.
/// - SeeAlso: https://github.com/swiftlang/swift-subprocess/issues/65#issuecomment-2970966110
public func withTimeout<T: Sendable>(
    in seconds: TimeInterval,
    isolation: isolated (any Actor)? = #isolation,
    body: @escaping () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await body()
        }

        group.addTask {
            await Task.sleep(seconds: seconds)
            throw TimeoutError()
        }

        guard let result = try await group.next() else {
            throw TimeoutError()
        }

        group.cancelAll()
        return result
    }
}

/// Internal timeout error for withTimeout function
internal struct TimeoutError: Error {
}
