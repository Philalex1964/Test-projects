//
//  PlayData.swift
//  UnitTestsSwift
//
//  Created by Aleksandar Filipov on 6/15/22.
//

import Foundation

class PlayData {
    var allWords = [String]()
//    var wordCounts = [String: Int]()
    var wordCounts: NSCountedSet!


    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter { $0 != "" }
                
//                for word in allWords {
//                    wordCounts[word, default: 0] += 1
//                }
//
//                allWords = Array(wordCounts.keys)
                
                wordCounts = NSCountedSet(array: allWords)
                let sorted = wordCounts.allObjects.sorted { wordCounts.count(for: $0) > wordCounts.count(for: $1) }
                allWords = sorted as! [String]
            }
        }
    }
}
