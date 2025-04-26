enum PrivacyLevel: String, Codable {
    case publicLevel = "PUBLIC"
    case friendsOnly = "FRIENDS"
    case privateLevel = "PRIVATE"
}

struct Wishlist: Codable {
    let id: Int
    var name: String
    var description: String
    var privacyLevel: PrivacyLevel

}
