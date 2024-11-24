import SwiftUI

@available(iOS 14.0, *)
public struct ExampleView: View {
    public init() {}
    
    public var body: some View {
        if let url = Bundle.module.url(forResource: "LoginView", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let component = try? JSONDecoder().decode(UIComponent.self, from: data) {
            UIGenerator.createView(from: component)
        } else {
            Text("Failed to load UI")
        }
    }
}

#if DEBUG
@available(iOS 14.0, *)
struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
#endif
