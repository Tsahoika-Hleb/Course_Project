import Foundation

struct ScoreSummary: Codable {
    let value: Double
    let type: String
}

struct AttributeScores: Codable {
    let summaryScore: ScoreSummary
}

struct APIResponse: Codable {
    let attributeScores: [String: AttributeScores]
    let languages: [String]
    let detectedLanguages: [String]
}
