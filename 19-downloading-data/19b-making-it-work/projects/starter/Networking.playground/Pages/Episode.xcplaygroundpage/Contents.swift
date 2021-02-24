//: ## Episode
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let baseUrlString = "https://api.raywenderlich.com/api/"
var urlComponents = URLComponents(
  string: baseUrlString + "contents/")!
urlComponents.queryItems = [
  URLQueryItem(
    name: "filter[subscription_types][]", value: "free"),
  URLQueryItem(
    name: "filter[content_types][]", value: "episode")
]
var baseParams = [
  "filter[subscription_types][]": "free",
  "filter[content_types][]": "episode",
  "sort": "-popularity",
  "page[size]": "20",
  "filter[q]": ""
]
urlComponents.setQueryItems(with: baseParams)
urlComponents.url?.absoluteString

let contentsUrl = urlComponents.url!  // 1
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .formatted(.apiDateFormatter)
// 2
URLSession.shared.dataTask(with: contentsUrl) {
  data, response, error in
  defer { PlaygroundPage.current.finishExecution() }
  if let data = data,
     let response = response as? HTTPURLResponse {  // 3
    print(response.statusCode)
    if let decodedResponse = try? decoder.decode(
        EpisodeStore.self, from: data) {
      DispatchQueue.main.async {
        print(decodedResponse.episodes[0].released)
        print(decodedResponse.episodes[0].domain)
      }
      return
    }
  }
  print(
    "Contents fetch failed: " +
      "\(error?.localizedDescription ?? "Unknown error")")  // 4
}
.resume()  // 5

struct EpisodeStore: Decodable {
  var episodes: [Episode] = []

  enum CodingKeys: String, CodingKey {
    case episodes = "data"   // array of dictionary
  }
}

struct Episode: Decodable, Identifiable {
  let id: String
  // flatten attributes container
  let uri: String
  let name: String
  let released: String
  let difficulty: String?
  let description: String  // description_plain_text

  var domain = ""  // relationships: domains: data: id

  // send request to /videos endpoint with urlString
  var videoUrl: VideoUrl?

  // redirects to the real web page
  var linkUrlString: String {
    "https://www.raywenderlich.com/redirect?uri=" + uri
  }

  enum DataKeys: String, CodingKey {
    case id
    case attributes
    case relationships
  }

  enum AttrsKeys: String, CodingKey {
    case uri, name, difficulty
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
    let releasedAt = try attrs.decode(
      String.self, forKey: .releasedAt)
    let releaseDate = Formatter.iso8601.date(  // 3
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
    self.released = DateFormatter.episodeDateFormatter.string(
      from: releaseDate)
    self.difficulty = difficulty
    self.description = description
    if let videoId = videoIdentifier {
      self.videoUrl = VideoUrl(videoId: videoId)
    }
  }
}

class VideoUrl {  // 1
  var urlString = ""

  init(videoId: Int) {
    let baseUrlString =
      "https://api.raywenderlich.com/api/videos/"
    let queryUrlString =
      baseUrlString + String(videoId) + "/stream"
    guard let queryUrl = URL(string: queryUrlString)
    else { return }  // 2
    URLSession.shared.dataTask(with: queryUrl) {
      data, response, error in
      //defer { PlaygroundPage.current.finishExecution() }  // 3
      if let data = data,
        let response = response as? HTTPURLResponse {
        print("\(videoId) \(response.statusCode)")
        if let decodedResponse = try? JSONDecoder().decode(
          VideoUrlString.self, from: data) {
          DispatchQueue.main.async {
            self.urlString = decodedResponse.urlString  // 4
            print(self.urlString)
          }
          return
        }
      }
      print(
        "Videos fetch failed: " +
          "\(error?.localizedDescription ?? "Unknown error")")
    }
    .resume()
  }
}

struct VideoUrlString {
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

extension VideoUrlString: Decodable {
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

//: [VideoUrl ->](@next)
