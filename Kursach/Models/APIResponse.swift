//
//  APIResponse.swift
//  Kursach
//
//  Created by user on 08/12/2023.
//

import Foundation

struct ApiResponse: Codable {
    let attributeScores: AttributeScores
    let languages: [String]
    let detectedLanguages: [String]

    struct AttributeScores: Codable {
        let toxicity: ToxityScore

        struct ToxityScore: Codable {
            let spanScores: [SpanScore]
            let summaryScore: Score

            struct SpanScore: Codable {
                let begin: Int
                let end: Int
                let score: Score
            }

            struct Score: Codable {
                let value: Double
                let type: String
            }
        }
    }
}
