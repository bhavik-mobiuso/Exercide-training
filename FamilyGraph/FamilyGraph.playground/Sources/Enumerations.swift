import Foundation

enum Model {
    
    case People
    case Relationships
}

enum CSVParseError: Error {
    case FileNotFound
}
