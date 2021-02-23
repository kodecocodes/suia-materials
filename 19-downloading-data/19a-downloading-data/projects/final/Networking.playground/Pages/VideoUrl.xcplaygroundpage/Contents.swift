//: [<- Episode](@previous)
//: ## VideoUrl
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

VideoUrl(videoId: 3021)
class VideoUrl {  // 1
  var urlString = ""

  init(videoId: Int) {
    let baseUrlString = "https://api.raywenderlich.com/api/videos/"
    let queryUrlString = baseUrlString + String(videoId) + "/stream"
    guard let queryUrl = URL(string: queryUrlString) else { return }  // 2
    URLSession.shared.dataTask(with: queryUrl) {
      data, response, error in
      defer { PlaygroundPage.current.finishExecution() }  // 3
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
    let container = try decoder.container(keyedBy: CodingKeys.self)  // 1
    let dataContainer = try container.nestedContainer(
      keyedBy: DataKeys.self, forKey: .data)  // 2
    let attr = try dataContainer.decode(
      VideoAttributes.self, forKey: .attributes)  // 3
    urlString = attr.url  // 4
  }
}

//struct ResponseData: Codable {
//  let data: Video
//}
//
//struct Video: Codable {
//  let attributes: VideoAttributes
//}
//
//struct VideoAttributes: Codable {
//  let url: URL
//}



