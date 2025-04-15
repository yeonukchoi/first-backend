//
//  CreatePostView.swift
//  Noticeboard
//
//  Created by yeonuk on 4/14/25.
//

import Foundation
import SwiftUI

struct CreatePostView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("제목을 입력하세요", text: $title)
                }
                Section(header: Text("내용")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }

                Button("작성 완료") {
                    createPost()
                }
                .disabled(title.isEmpty || content.isEmpty)
            }
            .navigationTitle("게시글 작성")
        }
    }

    func createPost() {
        guard let url = URL(string: "http://11.118.129.125:3000/posts") else { return }

        let postData: [String: Any] = [
            "title": title,
            "content": content
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("에러 발생: \(error.localizedDescription)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("응답 코드: \(response.statusCode)")
                }

                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }.resume()
        } catch {
            print("JSON 변환 오류: \(error)")
        }
    }

}
