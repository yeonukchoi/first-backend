import SwiftUI
import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case content
    }
}

struct ContentView: View {
    @State private var posts: [Post] = []
    @State private var selectedPostForEdit: Post? = nil
    @State private var isEditActive = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(posts) { post in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.headline)
                                Text(post.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            // 점 3개 버튼 (Menu)
                            Menu {
                                Button("수정") {
                                    selectedPostForEdit = post
                                    isEditActive = true
                                }
                                Button("삭제", role: .destructive) {
                                    deletePost(post.id)
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .refreshable {
                    await fetchPosts()
                }

                // 보이지 않는 NavigationLink (수정 화면 이동용)
                
                NavigationLink(
                    destination: selectedPostForEdit.map { EditPostView(post: $0) },
                    isActive: $isEditActive
                ) {
                    EmptyView()
                }
                .hidden()

            }
            .navigationTitle("게시판")
            .navigationBarItems(trailing:
                NavigationLink(destination: CreatePostView()) {
                    Image(systemName: "square.and.pencil")
                }
            )
        }
        .onAppear {
            Task {
                await fetchPosts()
            }
        }
    }

    func fetchPosts() async {
        guard let url = URL(string: "http://11.118.129.125:3000/posts") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Post].self, from: data)
            DispatchQueue.main.async {
                self.posts = decoded
            }
        } catch {
            print("데이터 불러오기 실패: \(error)")
        }
    }

    func deletePost(_ id: String) {
        guard let url = URL(string: "http://11.118.129.125:3000/posts/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("삭제 중 오류 발생: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                posts.removeAll { $0.id == id }
            }
        }.resume()
    }
}




#Preview {
    ContentView()
}
