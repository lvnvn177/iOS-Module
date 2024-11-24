// UIComponent.swift
import SwiftUI

public enum ComponentType: String, Codable {
    case text
    case image
    case button
    case stack
    case list
    case textField
    case toggle
    case spacer
}

public struct UIComponent: Codable {
    public let type: ComponentType
    public let id: String
    public var properties: [String: AnyCodable]
    public var children: [UIComponent]?
    
    // 스타일 관련 속성
    public var padding: CGFloat?
    public var backgroundColor: String?
    public var foregroundColor: String?
    public var cornerRadius: CGFloat?
    public var font: FontProperties?
    public var frame: FrameProperties?
    
    public init(type: ComponentType,
                id: String,
                properties: [String: AnyCodable],
                children: [UIComponent]? = nil,
                padding: CGFloat? = nil,
                backgroundColor: String? = nil,
                foregroundColor: String? = nil,
                cornerRadius: CGFloat? = nil,
                font: FontProperties? = nil,
                frame: FrameProperties? = nil) {
        self.type = type
        self.id = id
        self.properties = properties
        self.children = children
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.font = font
        self.frame = frame
    }
}

public struct FontProperties: Codable {
    public let size: CGFloat
    public let weight: String
    public let design: String
    
    public init(size: CGFloat, weight: String, design: String) {
        self.size = size
        self.weight = weight
        self.design = design
    }
}

public struct FrameProperties: Codable {
    public let width: CGFloat?
    public let height: CGFloat?
    public let maxWidth: CGFloat?
    public let maxHeight: CGFloat?
    
    public init(width: CGFloat? = nil,
                height: CGFloat? = nil,
                maxWidth: CGFloat? = nil,
                maxHeight: CGFloat? = nil) {
        self.width = width
        self.height = height
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
}

public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map(\.value)
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues(\.value)
        } else {
            value = ""
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let string as String:
            try container.encode(string)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let bool as Bool:
            try container.encode(bool)
        case let array as [Any]:
            try container.encode(array.map(AnyCodable.init))
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues(AnyCodable.init))
        default:
            try container.encodeNil()
        }
    }
}import SwiftUI

// UI 컴포넌트 타입 정의
enum ComponentType: String, Codable {
    case text
    case image
    case button
    case stack
    case list
    case textField
    case toggle
    case spacer
}

// 스택 방향 정의
enum StackDirection: String, Codable {
    case horizontal
    case vertical
}

// 정렬 옵션
enum AlignmentType: String, Codable {
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

// 기본 UI 컴포넌트 모델
struct UIComponent: Codable {
    let type: ComponentType
    let id: String
    var properties: [String: AnyCodable]
    var children: [UIComponent]?
    
    // 스타일 관련 속성
    var padding: CGFloat?
    var backgroundColor: String?
    var foregroundColor: String?
    var cornerRadius: CGFloat?
    var font: FontProperties?
    var frame: FrameProperties?
}

// 폰트 속성
struct FontProperties: Codable {
    let size: CGFloat
    let weight: String
    let design: String
}

// 프레임 속성
struct FrameProperties: Codable {
    let width: CGFloat?
    let height: CGFloat?
    let maxWidth: CGFloat?
    let maxHeight: CGFloat?
}

// JSON의 동적 값을 처리하기 위한 타입
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map(\.value)
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues(\.value)
        } else {
            value = ""
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let string as String:
            try container.encode(string)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let bool as Bool:
            try container.encode(bool)
        case let array as [Any]:
            try container.encode(array.map(AnyCodable.init))
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues(AnyCodable.init))
        default:
            try container.encodeNil()
        }
    }
}