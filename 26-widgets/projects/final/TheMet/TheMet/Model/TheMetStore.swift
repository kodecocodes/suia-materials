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
import WidgetKit

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier:
        "group.com.yourcompany.TheMet.objects")!
    // swiftlint:disable:previous force_unwrapping
  }
}

class TheMetStore: ObservableObject {
  @Published var objects: [Object] = []
  let service = TheMetService()
  let maxIndex: Int

  init(_ maxIndex: Int = 30) {
    self.maxIndex = maxIndex
  }

  func fetchObjects(for queryTerm: String) async throws {
    if let objectIDs = try await service.getObjectIDs(from: queryTerm) {  // 1
      for (index, objectID) in objectIDs.objectIDs.enumerated()  // 2
      where index < maxIndex {
        if let object = try await service.getObject(from: objectID) {
          await MainActor.run {
            objects.append(object)
          }
        }
      }
      writeObjects()
      WidgetCenter.shared.reloadTimelines(ofKind: "TheMetWidget")
    }
  }

  func writeObjects() {
    let archiveURL = FileManager.sharedContainerURL()
      .appendingPathComponent("objects.json")
    print(">>> \(archiveURL)")

    if let dataToSave = try? JSONEncoder().encode(objects) {
      do {
        try dataToSave.write(to: archiveURL)
      } catch {
        print("Error: Can’t write objects")
      }
    }
  }
}
