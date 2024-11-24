import SwiftUI

@available(iOS 14.0, *)
public struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    public init() {}
    
    public var body: some View {
        if let url = Bundle.module.url(forResource: "ProfileView", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let component = try? JSONDecoder().decode(UIComponent.self, from: data) {
            ScrollView {
                UIGenerator.createView(from: component)
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.loadProfile()
            }
        } else {
            Text("Failed to load profile UI")
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    
    func loadProfile() {
        // 여기서 실제 프로필 데이터를 로드합니다
        // API 호출이나 로컬 저장소에서 데이터를 가져올 수 있습니다
    }
}

struct Profile: Codable {
    let name: String
    let email: String
    let posts: Int
    let followers: Int
    let following: Int
}

#if DEBUG
@available(iOS 14.0, *)
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
#endif
