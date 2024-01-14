enum VoteOption: Int32, Codable {
    static let schema = "vote_option"
    case noVote = 0
    case liked = 1
    case disliked = -1
}
