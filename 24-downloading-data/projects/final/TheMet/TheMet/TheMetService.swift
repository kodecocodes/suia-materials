/// Copyright (c) 2023 Kodeco LLC
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

struct TheMetService {
  let baseURLString = "https://collectionapi.metmuseum.org/public/collection/v1/"
  let session = URLSession.shared
  let decoder = JSONDecoder()

  func getObjectIDs(from queryTerm: String) async throws -> ObjectIDs? {
    let objectIDs: ObjectIDs?  // 1

    guard var urlComponents = URLComponents(string: baseURLString + "search") else {  // 2
      return nil
    }
    let baseParams = ["hasImages": "true"]
    urlComponents.setQueryItems(with: baseParams)
    // swiftlint:disable:next force_unwrapping
    urlComponents.queryItems! += [URLQueryItem(name: "q", value: queryTerm)]
    guard let queryURL = urlComponents.url else { return nil }
    let request = URLRequest(url: queryURL)

    let (data, response) = try await session.data(for: request)  // 1
    guard
      let response = response as? HTTPURLResponse,
      (200..<300).contains(response.statusCode)
    else {
      print(">>> getObjectIDs response outside bounds")
      return nil
    }

    do {  // 2
      objectIDs = try decoder.decode(ObjectIDs.self, from: data)
    } catch {
      print(error)
      return nil
    }
    return objectIDs  // 3
  }

  func getObject(from objectID: Int) async throws -> Object? {
    let object: Object?  // 1

    let objectURLString = baseURLString + "objects/\(objectID)"  // 2
    guard let objectURL = URL(string: objectURLString) else { return nil }
    let objectRequest = URLRequest(url: objectURL)

    let (data, response) = try await session.data(for: objectRequest)  // 3
    if let response = response as? HTTPURLResponse {
      let statusCode = response.statusCode
      if !(200..<300).contains(statusCode) {
        print(">>> getObject response \(statusCode) outside bounds")
        print(">>> \(objectURLString)")
        return nil
      }
    }

    do {  // 4
      object = try decoder.decode(Object.self, from: data)
    } catch {
      print(error)
      return nil
    }
    return object  // 5
  }
}
