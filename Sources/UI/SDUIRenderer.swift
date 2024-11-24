import SwiftUI

public struct SDUIRenderer {
    public static func render(_ component: SDUIComponent) -> some View {
        renderComponent(component)
    }
    
    private static func renderComponent(_ component: SDUIComponent) -> some View {
        Group {
            switch component.type {
            case .text:
                renderText(component)
            case .image:
                renderImage(component)
            case .button:
                renderButton(component)
            case .stack:
                renderStack(component)
            case .spacer:
                Spacer()
            case .list:
                renderList(component)
            }
        }
        .modifier(StyleModifier(style: component.style))
    }
    
    private static func renderText(_ component: SDUIComponent) -> some View {
        Text(component.content ?? "")
    }
    
    private static func renderImage(_ component: SDUIComponent) -> some View {
        AsyncImage(url: URL(string: component.content ?? "")) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private static func renderButton(_ component: SDUIComponent) -> some View {
        Button(action: {
            // Handle action here
            print("Button tapped: \(component.action?.type ?? "")")
        }) {
            Text(component.content ?? "")
        }
    }
    
    private static func renderStack(_ component: SDUIComponent) -> some View {
        Group {
            if component.stackAxis == .horizontal {
                HStack(alignment: .center) {
                    ForEach(component.children ?? [], id: \.id) { child in
                        renderComponent(child)
                    }
                }
            } else {
                VStack(alignment: component.stackAlignment?.alignment ?? .center) {
                    ForEach(component.children ?? [], id: \.id) { child in
                        renderComponent(child)
                    }
                }
            }
        }
    }
    
    private static func renderList(_ component: SDUIComponent) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(component.children ?? [], id: \.id) { child in
                    renderComponent(child)
                }
            }
        }
    }
}

private struct StyleModifier: ViewModifier {
    let style: SDUIStyle?
    
    func body(content: Content) -> some View {
        content
            .padding(style?.padding ?? 0)
            .background(Color(hex: style?.backgroundColor ?? "#00000000"))
            .foregroundColor(Color(hex: style?.foregroundColor ?? "#000000"))
            .cornerRadius(style?.cornerRadius ?? 0)
            .font(.system(size: style?.fontSize ?? 16))
            .fontWeight(convertFontWeight(style?.fontWeight))
            .frame(
                width: style?.width != nil ? CGFloat(style?.width ?? 0) : nil,
                height: style?.height != nil ? CGFloat(style?.height ?? 0) : nil
            )
    }
    
    private func convertFontWeight(_ weight: Int?) -> Font.Weight {
        guard let weight = weight else { return .regular }
        switch weight {
        case 100: return .ultraLight
        case 200: return .thin
        case 300: return .light
        case 400: return .regular
        case 500: return .medium
        case 600: return .semibold
        case 700: return .bold
        case 800: return .heavy
        case 900: return .black
        default: return .regular
        }
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
