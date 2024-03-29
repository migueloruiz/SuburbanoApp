//
//  String.swift
//  suburbano
//
//  Created by Miguel Ruiz on 19/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }

    func matchesPattern(pattern: String) -> Bool {
        guard !isEmpty || !pattern.isEmpty else { return false }
        guard range(of: pattern, options: .regularExpression) != nil else { return false }
        return true
    }

    func matches(forRegex regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(startIndex..., in: self))
            return results.compactMap({ (result) -> String? in
                guard let range = Range(result.range, in: self) else { return nil }
                return String(self[range])
            })
        } catch {
            return []
        }
    }

    func firstMatch(forRegex regex: String) -> String? {
        return self.matches(forRegex: regex).first
    }
}
