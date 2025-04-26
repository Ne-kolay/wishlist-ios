import Foundation

struct GiftDTO: Decodable {
    let name: String
    let estimatedPrice: Double
    let description: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case estimatedPrice
        case description
        case link
    }
}
