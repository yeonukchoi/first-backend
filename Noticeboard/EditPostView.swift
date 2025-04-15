//
//  EditPostView.swift
//  Noticeboard
//
//  Created by yeonuk on 4/14/25.
//

import Foundation
import SwiftUI

struct EditPostView: View {
    var post: Post
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String
    @State private var content: String

    init(post: Post) {
        self.post = post
        _title = State(initialValue: post.title)
        _content = State(initialValue: post.content)
    }

    var body: some View {
        Form {
            Section(header: Text("제목")) {
                TextField("제목", text: $title)
            }
            Section(header: Text("내용")) {
                TextEditor(text: $content)
                    .frame(height: 200)
            }

            Button("수정 완료") {
                updatePost()
            }
            .disabled(title.isEmpty || content.isEmpty)
        }
        .navigationTitle("게시글 수정")
    }

    func updatePost() {
        guard let url = URL(string: "http://11.118.129.125:3000/posts/\(post.id)") else { return }

        let updatedData: [String: Any] = [
            "title": title,
            "content": content
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: updatedData)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("업데이트 실패: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        }.resume()
    }
}
