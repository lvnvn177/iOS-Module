import SwiftUI

public enum SDUIComponentType: String, Codable {
    case text
    case image
    case button
    case stack
    case spacer
    case list
}

public enum SDUIStackAlignment: String, Codable {
    case leading
    case center
    case trailing
    
    var alignment: HorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

public enum SDUIStackAxis: String, Codable {
    case horizontal
    case vertical
}

public struct SDUIStyle: Codable {
    public var padding: CGFloat?
    public var backgroundColor: String?
    public var foregroundColor: String?
    public var cornerRadius: CGFloat?
    public var fontSize: CGFloat?
    public var fontWeight: Int?
    public var width: CGFloat?
    public var height: CGFloat?
    
    public init(padding: CGFloat? = nil,
               backgroundColor: String? = nil,
               foregroundColor: String? = nil,
               cornerRadius: CGFloat? = nil,
               fontSize: CGFloat? = nil,
               fontWeight: Int? = nil,
               width: CGFloat? = nil,
               height: CGFloat? = nil) {
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.width = width
        self.height = height
    }
}

public struct SDUIComponent: Codable {
    public let type: SDUIComponentType
    public let id: String
    public var content: String?
    public var style: SDUIStyle?
    public var action: SDUIAction?
    public var children: [SDUIComponent]?
    public var stackAxis: SDUIStackAxis?
    public var stackAlignment: SDUIStackAlignment?
    
    public init(type: SDUIComponentType,
               id: String,
               content: String? = nil,
               style: SDUIStyle? = nil,
               action: SDUIAction? = nil,
               children: [SDUIComponent]? = nil,
               stackAxis: SDUIStackAxis? = nil,
               stackAlignment: SDUIStackAlignment? = nil) {
        self.type = type
        self.id = id
        self.content = content
        self.style = style
        self.action = action
        self.children = children
        self.stackAxis = stackAxis
        self.stackAlignment = stackAlignment
    }
}

public struct SDUIAction: Codable {
    public let type: String
    public let payload: [String: String]
    
    public init(type: String, payload: [String: String]) {
        self.type = type
        self.payload = payload
    }
}
