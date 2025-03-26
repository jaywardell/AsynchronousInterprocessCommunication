//
//  NSItemProvider+Objects.swift
//  Image Reader
//
//  Created by Joseph Wardell on 3/26/25.
//

import Foundation
import CoreGraphics

@available(macOS 10.15, iOS 13, *)
public extension NSItemProvider {
    
    /// retrieve an object of the type passed in
    /// - Parameter type: the type of object you want (e.g. NSImage.self)
    /// - Returns: an instance of the type requested if one is available, otherwise nil
    ///
    /// NOTE: it's advisable to not call this method directly.
    /// To avoid async/await warnings and errors,
    /// add a @MainActor method on NSItemProvider that calls this method internally
    /// and convert the object to a Sendable type before returning
    /// see `getCGImage()` for an example
    @MainActor
    @preconcurrency
    func getObject<T: NSObject>(type: T.Type) async throws -> sending T
    where T: NSItemProviderReading {
        try await withCheckedThrowingContinuation { continuation in
            if canLoadObject(ofClass: T.self) {
                loadObject(ofClass: T.self) { object, _ in
                    guard let image = object as? T else {
                        return continuation.resume(throwing: NSError())
                    }
                    let tosend: T = image.copy() as! T
                    continuation.resume(returning: tosend)
                }
            }
            else {
                continuation.resume(throwing: NSError())
            }
        }
    }
}

