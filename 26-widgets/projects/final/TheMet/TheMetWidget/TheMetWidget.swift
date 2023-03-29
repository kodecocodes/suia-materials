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

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), object: Object.sample(isPublicDomain: true))
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), object: Object.sample(isPublicDomain: false))
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    let interval = 3

    let objects = readObjects()
    for index in 0 ..< objects.count {
      let entryDate = Calendar.current.date(
        byAdding: .second,
        value: index * interval,
        // swiftlint:disable:next force_unwrapping
        to: currentDate)!
      let entry = SimpleEntry(
        date: entryDate,
        object: objects[index])
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .never)
    completion(timeline)
  }

  func readObjects() -> [Object] {
    var objects: [Object] = []
    let archiveURL =
      FileManager.sharedContainerURL()
      .appendingPathComponent("objects.json")
    print(">>> \(archiveURL)")

    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        objects = try JSONDecoder()
          .decode([Object].self, from: codeData)
      } catch {
        print("Error: Can’t decode contents")
      }
    }
    return objects
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let object: Object
}

struct TheMetWidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    WidgetView(entry: entry)
  }
}

struct TheMetWidget: Widget {
  let kind: String = "TheMetWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      TheMetWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("The Met")
    .description("View objects from the Metropolitan Museum.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}

struct TheMetWidget_Previews: PreviewProvider {
  static var previews: some View {
    TheMetWidgetEntryView(
      entry: SimpleEntry(
        date: Date(),
        object: Object.sample(isPublicDomain: true)))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
