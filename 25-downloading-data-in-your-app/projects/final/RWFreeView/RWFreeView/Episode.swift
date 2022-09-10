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

struct Episode: Decodable, Identifiable {
  let id: String
  // flatten attributes container
  let uri: String
  let name: String
  let parentName: String?
  let released: String
  let difficulty: String?
  let description: String  // description_plain_text

  var domain = ""  // relationships: domains: data: id

  // send request to /videos endpoint with urlString
  var videoURL: VideoURL?

  // redirects to the real web page
  var linkURLString: String {
    "https://www.raywenderlich.com/redirect?uri=" + uri
  }

  enum DataKeys: String, CodingKey {
    case id
    case attributes
    case relationships
  }

  enum AttrsKeys: String, CodingKey {
    case uri, name, difficulty
    case parentName = "parent_name"
    case releasedAt = "released_at"
    case description = "description_plain_text"
    case videoIdentifier = "video_identifier"
  }

  struct Domains: Codable {
    let data: [[String: String]]
  }

  enum RelKeys: String, CodingKey {
    case domains
  }

  static let domainDictionary = [
    "1": "iOS & Swift",
    "2": "Android & Kotlin",
    "3": "Unity",
    "5": "macOS",
    "8": "Server-Side Swift",
    "9": "Flutter"
  ]
}

extension Episode {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(  // 1
      keyedBy: DataKeys.self)
    let id = try container.decode(String.self, forKey: .id)

    let attrs = try container.nestedContainer(  // 2
      keyedBy: AttrsKeys.self, forKey: .attributes)
    let uri = try attrs.decode(String.self, forKey: .uri)
    let name = try attrs.decode(String.self, forKey: .name)
    let parentName = try attrs.decode(String?.self, forKey: .parentName)
    let releasedAt = try attrs.decode(
      String.self, forKey: .releasedAt)
    let releaseDate = Formatter.iso8601.date(  // 3
      // swiftlint:disable:next force_unwrapping
      from: releasedAt)!
    let difficulty = try attrs.decode(
      String?.self, forKey: .difficulty)
    let description = try attrs.decode(
      String.self, forKey: .description)
    let videoIdentifier = try attrs.decode(
      Int?.self, forKey: .videoIdentifier)

    let rels = try container.nestedContainer(
      keyedBy: RelKeys.self, forKey: .relationships)  // 4
    let domains = try rels.decode(
      Domains.self, forKey: .domains)
    if let domainId = domains.data.first?["id"] {  // 5
      self.domain = Episode.domainDictionary[domainId] ?? ""
    }

    self.id = id
    self.uri = uri
    self.name = name
    self.parentName = parentName
    self.released = DateFormatter.episodeDateFormatter.string(
      from: releaseDate)
    self.difficulty = difficulty
    self.description = description
    if let videoId = videoIdentifier {
      self.videoURL = VideoURL(videoId: videoId)
    }
  }
}
