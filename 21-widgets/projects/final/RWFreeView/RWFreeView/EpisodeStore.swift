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
import WidgetKit

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier:
        "group.your.prefix.RWFreeView.episodes"
      // swiftlint:disable:next force_unwrapping
    )!
  }
}

final class EpisodeStore: ObservableObject, Decodable {
  @Published var episodes: [Episode] = []
  var miniEpisodes: [MiniEpisode] = []

  func writeEpisodes() {
    let archiveURL = FileManager.sharedContainerURL()
      .appendingPathComponent("episodes.json")
    print(">>> \(archiveURL)")

    if let dataToSave = try? JSONEncoder().encode(miniEpisodes) {
      do {
        try dataToSave.write(to: archiveURL)
      } catch {
        print("Error: Can't write episodes")
        return
      }
    }
  }

  @Published var loading = false
  @Published var domainFilters: [String: Bool] = [
    "1": true,
    "2": false,
    "3": false,
    "5": false,
    "8": false,
    "9": false
  ]
  @Published var difficultyFilters: [String: Bool] = [
    "advanced": false,
    "beginner": true,
    "intermediate": false
  ]

  func queryDomain(_ id: String) -> URLQueryItem {
    URLQueryItem(name: "filter[domain_ids][]", value: id)
  }

  func queryDifficulty(_ label: String) -> URLQueryItem {
    URLQueryItem(name: "filter[difficulties][]", value: label)
  }

  func clearQueryFilters() {
    domainFilters.keys.forEach { domainFilters[$0] = false }
    difficultyFilters.keys.forEach { difficultyFilters[$0] = false }
  }

  let filtersDictionary = [
    "1": "iOS & Swift",
    "2": "Android & Kotlin",
    "3": "Unity",
    "5": "macOS",
    "8": "Server-Side Swift",
    "9": "Flutter",
    "advanced": "Advanced",
    "beginner": "Beginner",
    "intermediate": "Intermediate"
  ]

  // 1
  let baseUrlString = "https://api.raywenderlich.com/api/contents"
  // use baseParams dictionary for free, episode, sort, page size, search term
  var baseParams = [
    "filter[subscription_types][]": "free",
    "filter[content_types][]": "episode",
    "sort": "-popularity",
    "page[size]": "20",
    "filter[q]": ""
  ]
  // 2
  func fetchContents() {
    guard var urlComponents = URLComponents(string: baseUrlString) else { return }
    urlComponents.setQueryItems(with: baseParams)
    let selectedDomains = domainFilters.filter {
      $0.value
    }
    .keys
    let domainQueryItems = selectedDomains.map {
      queryDomain($0)
    }

    let selectedDifficulties = difficultyFilters.filter {
      $0.value
    }
    .keys
    let difficultyQueryItems = selectedDifficulties.map {
      queryDifficulty($0)
    }

    // swiftlint:disable:next force_unwrapping
    urlComponents.queryItems! += domainQueryItems
    // swiftlint:disable:next force_unwrapping
    urlComponents.queryItems! += difficultyQueryItems
    guard let contentsUrl = urlComponents.url else { return }
    print(contentsUrl)

    loading = true
    URLSession.shared.dataTask(with: contentsUrl) { data, response, error in
      if let data = data, let response = response as? HTTPURLResponse {
        print(response.statusCode)
        if let decodedResponse = try? JSONDecoder().decode(  // 1
          EpisodeStore.self, from: data) {
          DispatchQueue.main.async {
            self.episodes = decodedResponse.episodes  // 2
            self.loading = false
            self.miniEpisodes = self.episodes.map {
              MiniEpisode(
                id: $0.id,
                name: $0.name,
                released: $0.released,
                domain: $0.domain,
                difficulty: $0.difficulty ?? "",
                description: $0.description)
            }
            self.writeEpisodes()
            WidgetCenter.shared.reloadTimelines(ofKind: "RWFreeViewWidget")
          }
          return
        }
      }
      print("Contents fetch failed: \(error?.localizedDescription ?? "Unknown error")")
      DispatchQueue.main.async {
        self.loading = false
      }
    }
    .resume()
  }

  init() {
    fetchContents()
  }

  // 1
  enum CodingKeys: String, CodingKey {
    case episodes = "data"   // array of dictionary
  }
  // 2
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    episodes = try container.decode([Episode].self, forKey: .episodes)
  }
}
