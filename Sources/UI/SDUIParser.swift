import Foundation

public class SDUIParser {
    public static func parse(json: String) throws -> SDUIComponent {
        guard let jsonData = json.data(using: .utf8) else {
            throw SDUIError.invalidJSON
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SDUIComponent.self, from: jsonData)
        } catch {
            throw SDUIError.parsingFailed(error)
        }
    }
    
    public static func parse(jsonData: Data) throws -> SDUIComponent {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SDUIComponent.self, from: jsonData)
        } catch {
            throw SDUIError.parsingFailed(error)
        }
    }
}

public enum SDUIError: Error {
    case invalidJSON
    case parsingFailed(Error)
    case renderingFailed(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidJSON:
            return "Invalid JSON format"
        case .parsingFailed(let error):
            return "Failed to parse JSON: \(error.localizedDescription)"
        case .renderingFailed(let message):
            return "Failed to render component: \(message)"
        }
    }
}
