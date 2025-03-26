//
//  NSExtensionContext+DictionaryRetrieval.swift
//  SkyMarkShareExtension
//
//  Created by Joseph Wardell on 11/27/24.
//

import Foundation
import UniformTypeIdentifiers

@available(macOS 11, iOS 14, *)
public extension NSExtensionContext {
    
    func getPageDataFromExtensionContext() async -> [[String: Any]] {
        guard let extensionItems = inputItems as? [NSExtensionItem] else { return [] }
        
        var out = [[String: Any]]()
        for item in extensionItems {
            out += await item.propertyListsAsDictionaries()
        }
        
        return out
    }
    
    func getValues<Output>(for typeIdentifier: UTType) async -> [Output] {
        guard let extensionItems = inputItems as? [NSExtensionItem] else { return [] }

        var out = [Output]()
        for item in extensionItems {
            out += await item.getValues(for: typeIdentifier)
        }
        
        return out
    }
    
    /// macOS provides shared URLs in an extension context as Data objects
    /// while iOS provides straight URLs
    ///
    /// so this method traverses the context looking for any type that matches the UTType.url
    /// and provides SOME value that can be interpreted as an URL
    func getURLs() async -> [URL] {
        guard let extensionItems = inputItems as? [NSExtensionItem] else { return [] }

        var out = [URL]()
        for item in extensionItems {
            out += await item.getURLs()
        }
        
        return out
    }
}
