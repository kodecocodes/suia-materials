/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class VideoURL: ObservableObject {
  @Published var urlString = ""

  init(videoId: Int) {
    let baseURLString = "https://api.raywenderlich.com/api/videos/"
    let queryURLString = baseURLString + String(videoId) + "/stream"
    guard let queryURL = URL(string: queryURLString) else { return }
    URLSession.shared.dataTask(with: queryURL) { data, response, error in
      if let data = data, let response = response as? HTTPURLResponse {
        // 1
        if response.statusCode != 200 {
          print("\(videoId) \(response.statusCode)")
          return
        }
        if let decodedResponse = try? JSONDecoder().decode(
          VideoURLString.self, from: data) {
          // 2
          self.urlString = decodedResponse.urlString
        }
      } else {
        print("Videos fetch failed: \(error?.localizedDescription ?? "Unknown error")")
      }
    }
    .resume()
  }
}

struct VideoURLString {
  // data: attributes: url
  var urlString: String

  enum CodingKeys: CodingKey {
    case data
  }

  enum DataKeys: CodingKey {
    case attributes
  }
}

struct VideoAttributes: Codable {
  var url: String
}

extension VideoURLString: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(  // 1
      keyedBy: CodingKeys.self)
    let dataContainer = try container.nestedContainer(
      keyedBy: DataKeys.self, forKey: .data)  // 2
    let attr = try dataContainer.decode(
      VideoAttributes.self, forKey: .attributes)  // 3
    urlString = attr.url  // 4
  }
}
