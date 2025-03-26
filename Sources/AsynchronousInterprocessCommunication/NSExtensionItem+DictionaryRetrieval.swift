//
//  NSExtensionItem+DictionaryRetrieval.swift
//  SkyMarkShareExtension
//
//  Created by Joseph Wardell on 11/27/24.
//

import Foundation
import UniformTypeIdentifiers

@available(macOS 11, iOS 14, *)
public extension NSExtensionItem {
    
    func propertyListsAsDictionaries() async -> [[String: Any]] {
        guard let attachments else { return [] }
        
        var out = [[String: Any]]()
        for itemProvider in attachments {
            guard let gotit = await itemProvider.propertyListAsDictionary() else { continue }
            out.append(gotit)
        }
        return out
    }
    
    func getValues<Output>(for typeIdentifier: UTType) async -> [Output] {
        guard let attachments else { return [] }
        
        var out = [Output]()
        for itemProvider in attachments {
            if let retrieved: Output = await itemProvider.getValue(for: typeIdentifier) {
                out.append(retrieved)
            }
        }
        return out
    }
    
    func getURLs() async -> [URL] {
        guard let attachments else { return [] }

        var out = [URL]()
        for itemProvider in attachments {
            if let retrieved = await itemProvider.getURL() {
                out.append(retrieved)
            }
        }
        return out
    }
}
