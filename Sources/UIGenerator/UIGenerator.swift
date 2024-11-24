import SwiftUI

@available(iOS 14.0, *)
public struct UIGenerator {
    public static func createView(from component: UIComponent) -> some View {
        generateComponent(component)
    }
    
    private static func generateComponent(_ component: UIComponent) -> some View {
        Group {
            switch component.type {
            case .text:
                createText(from: component)
            case .button:
                createButton(from: component)
            case .stack:
                createStack(from: component)
            case .image:
                createImage(from: component)
            case .textField:
                createTextField(from: component)
            case .toggle:
                createToggle(from: component)
            case .list:
                createList(from: component)
            case .spacer:
                Spacer()
            }
        }
        .modifier(ComponentModifier(component: component))
    }
    
    private static func createText(from component: UIComponent) -> some View {
        let text = component.properties["text"]?.value as? String ?? ""
        return Text(text)
    }
    
    private static func createButton(from component: UIComponent) -> some View {
        let title = component.properties["title"]?.value as? String ?? ""
        return Button(title) {
            // Action can be handled through a callback system
        }
    }
    
    private static func createStack(from component: UIComponent) -> some View {
        let direction = (component.properties["direction"]?.value as? String).flatMap(StackDirection.init) ?? .vertical
        let spacing = component.properties["spacing"]?.value as? CGFloat ?? 8
        
        let content = component.children ?? []
        
        return Group {
            if direction == .vertical {
                VStack(spacing: spacing) {
                    ForEach(content, id: \.id) { child in
                        generateComponent(child)
                    }
                }
            } else {
                HStack(spacing: spacing) {
                    ForEach(content, id: \.id) { child in
                        generateComponent(child)
                    }
                }
            }
        }
    }
    
    private static func createImage(from component: UIComponent) -> some View {
        let systemName = component.properties["systemName"]?.value as? String ?? "photo"
        return Image(systemName: systemName)
            .resizable()
            .scaledToFit()
    }
    
    private static func createTextField(from component: UIComponent) -> some View {
        let placeholder = component.properties["placeholder"]?.value as? String ?? ""
        let text = Binding(
            get: { component.properties["text"]?.value as? String ?? "" },
            set: { _ in }
        )
        return TextField(placeholder, text: text)
    }
    
    private static func createToggle(from component: UIComponent) -> some View {
        let title = component.properties["title"]?.value as? String ?? ""
        let isOn = Binding(
            get: { component.properties["isOn"]?.value as? Bool ?? false },
            set: { _ in }
        )
        return Toggle(title, isOn: isOn)
    }
    
    private static func createList(from component: UIComponent) -> some View {
        let content = component.children ?? []
        return ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(content, id: \.id) { child in
                    generateComponent(child)
                }
            }
        }
    }
}

struct ComponentModifier: ViewModifier {
    let component: UIComponent
    
    func body(content: Content) -> some View {
        content
            .padding(component.padding ?? 0)
            .background(Color(hex: component.backgroundColor ?? "#00000000"))
            .foregroundColor(Color(hex: component.foregroundColor ?? "#000000"))
            .cornerRadius(component.cornerRadius ?? 0)
            .modifier(FrameModifier(frame: component.frame))
            .modifier(FontModifier(font: component.font))
    }
}

struct FrameModifier: ViewModifier {
    let frame: FrameProperties?
    
    func body(content: Content) -> some View {
        content.frame(
            width: frame?.width,
            height: frame?.height,
            maxWidth: frame?.maxWidth,
            maxHeight: frame?.maxHeight
        )
    }
}

struct FontModifier: ViewModifier {
    let font: FontProperties?
    
    func body(content: Content) -> some View {
        content.font(createFont())
    }
    
    private func createFont() -> Font {
        guard let font = font else { return .body }
        
        var baseFont: Font = .system(size: font.size)
        
        // Apply font weight
        switch font.weight.lowercased() {
        case "bold": baseFont = .system(size: font.size, weight: .bold)
        case "light": baseFont = .system(size: font.size, weight: .light)
        case "medium": baseFont = .system(size: font.size, weight: .medium)
        default: break
        }
        
        // Apply font design
        switch font.design.lowercased() {
        case "serif": baseFont = .system(size: font.size, design: .serif)
        case "rounded": baseFont = .system(size: font.size, design: .rounded)
        case "monospaced": baseFont = .system(size: font.size, design: .monospaced)
        default: break
        }
        
        return baseFont
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
