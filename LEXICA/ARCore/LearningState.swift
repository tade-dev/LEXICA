import Foundation

/// Represents the current phase of an AR learning session.
enum LearningState: Equatable {
    case singleLetter(Character)
    case letterComparison(Character, Character)
    case wordAssembly([Character])
    case wordCompleted(String)
    case anchoredWord(String)

    /// A short instruction string describing what the learner should do next.
    var instructionText: String {
        switch self {
        case .singleLetter(let letter):
            return "This is the letter \"\(letter)\". Tap to hear it."
        case .letterComparison(let first, let second):
            return "Compare \"\(first)\" and \"\(second)\". Spot the difference."
        case .wordAssembly(let letters):
            let word = String(letters)
            return "Drag the letters to build \"\(word)\"."
        case .wordCompleted(let word):
            return "Great job! You spelled \"\(word)\"."
        case .anchoredWord(let word):
            return "\"\(word)\" is placed in your space. Walk around it!"
        }
    }
}
