import SwiftUI

public enum SDUIComponentType: String, Codable {  // UI 컴포넌트 타입
    case text
    case image
    case button
    case stack
    case spacer
    case list
}

public enum SDUIStackAlignment: String, Codable { // UI 조정 옵션
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

public enum SDUIStackAxis: String, Codable { // UI 정령 방향
    case horizontal
    case vertical
}

public struct SDUIStyle: Codable { // UI 커스텀 사항
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

public struct SDUIComponent: Codable { // 앞서 정의한 UI 구조체들로 구성된 컴포넌트
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

public struct SDUIAction: Codable { // 컴포넌트 액션 구분 및 구현, 아직 미구현
    public let type: String
    public let payload: [String: String]
    
    public init(type: String, payload: [String: String]) {
        self.type = type
        self.payload = payload
    }
}
