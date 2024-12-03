import Foundation

struct Recipe: Codable {
    let id: Int
    let title: String
    let summary: String
    let readyInMinutes: Int
    let servings: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, summary, readyInMinutes, servings
    }
}
