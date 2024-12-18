import SwiftUI

public enum SDUIComponentType: String, Codable {  // UI 컴포넌트 타입
    case text
    case image
    case button
    case stack
    case spacer // ?
    case list
    case scroll
}

public enum SDUIStackAlignment: String, Codable { // UI 조정 옵션
    case leading
    case center
    case trailing
    
    public var alignment: HorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

public enum TextAlignment: String, Codable { // Text 정렬 방향
    case leading
    case center
    case trailing
}



public enum SDUIStackAxis: String, Codable { // UI 정렬 방향
    case horizontal
    case vertical
}

public enum SDUIScrollAxis: String, Codable { // Scroll 정렬 방향
    case horizontal
    case vertical
}

public struct SDUIStyle: Codable { // UI 커스텀 사항
    public var padding: CGFloat?
    public var spacing: CGFloat?
    public var backgroundColor: String?
    public var foregroundColor: String?
    public var cornerRadius: CGFloat?
    public var fontSize: CGFloat?
    public var fontWeight: Int?
    public var width: CGFloat?
    public var height: CGFloat?
    
    public var alignment: TextAlignment?  // 추가
        
        public enum TextAlignment: String, Codable {
            case leading
            case center
            case trailing
    }
    
    public init(
               padding: CGFloat? = nil,
               spacing: CGFloat? = nil,
               backgroundColor: String? = nil,
               foregroundColor: String? = nil,
               cornerRadius: CGFloat? = nil,
               fontSize: CGFloat? = nil,
               fontWeight: Int? = nil,
               width: CGFloat? = nil,
               height: CGFloat? = nil,
               alignment: TextAlignment? = nil) {
        self.padding = padding
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.width = width
        self.height = height
        self.alignment = alignment
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
    public var scrollAxis: SDUIScrollAxis?
    public var showIndicators: Bool?
    
    public init(type: SDUIComponentType,
               id: String,
               content: String? = nil,
               style: SDUIStyle? = nil,
               action: SDUIAction? = nil,
               children: [SDUIComponent]? = nil,
               stackAxis: SDUIStackAxis? = nil,
               stackAlignment: SDUIStackAlignment? = nil,
               scrollAxis: SDUIScrollAxis? = nil,
               showIndicators: Bool? = nil) {
        self.type = type
        self.id = id
        self.content = content
        self.style = style
        self.action = action
        self.children = children
        self.stackAxis = stackAxis
        self.stackAlignment = stackAlignment
        self.scrollAxis = scrollAxis
        self.showIndicators = showIndicators ?? false
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

// MARK: - Content Updatable Protocol
public protocol SDUIContentUpdatable { // SDUIComponent - interface
    mutating func updateContent(_ newContent: Any, for identifier: String)
    func findComponent(by identifier: String) -> SDUIComponent?
}

extension SDUIComponent: SDUIContentUpdatable {
    public mutating func updateContent(_ newContent: Any, for identifier: String) {
        // 현재 컴포넌트의 id가 일치하는지 확인
//        if self.id == identifier {
//            self.content = "\(newContent)"
//        }

        if self.id == identifier {
                    // newContent가 배열이고 SDUIComponent 배열인 경우 children 업데이트
                    if let newComponents = newContent as? [SDUIComponent] {
                        self.children = newComponents
                    } else {
                        // 기존처럼 content 업데이트
                        self.content = "\(newContent)"
                    }
        }
        // 자식 컴포넌트들도 재귀적으로 검색하여 업데이트
        children?.indices.forEach { index in
            children?[index].updateContent(newContent, for: identifier)
        }
    }
    
    public func findComponent(by identifier: String) -> SDUIComponent? {
        // 현재 컴포넌트의 id가 일치하는지 확인
        if self.id == identifier {
            return self
        }
        
        // 자식 컴포넌트들을 재귀적으로 검색
        if let children = self.children {
            for child in children {
                if let found = child.findComponent(by: identifier) {
                    return found
                }
            }
        }
        
        return nil
    }
}
