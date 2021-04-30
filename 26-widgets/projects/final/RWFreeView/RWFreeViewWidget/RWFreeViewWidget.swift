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

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  let sampleEpisode = MiniEpisode(
    id: "5117655",
    name: "SwiftUI vs. UIKit",
    released: "Sept 2019",
    domain: "iOS & Swift",
    difficulty: "beginner",
    description: "Learn about the differences between SwiftUI and UIKit, " +
      "and whether you should learn SwiftUI, UIKit, or both.\n")

  func readEpisodes() -> [MiniEpisode] {
    var episodes: [MiniEpisode] = []
    let archiveURL =
      FileManager.sharedContainerURL()
      .appendingPathComponent("episodes.json")
    print(">>> \(archiveURL)")

    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        episodes = try JSONDecoder().decode(
          [MiniEpisode].self,
          from: codeData)
      } catch {
        print("Error: Can't decode contents")
      }
    }
    return episodes
  }

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), episode: sampleEpisode)
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), episode: sampleEpisode)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    let interval = 3
    let episodes = readEpisodes()
    for index in 0 ..< episodes.count {
      let entryDate = Calendar.current.date(
        byAdding: .second,
        value: index * interval,
        // swiftlint:disable:next force_unwrapping
        to: currentDate)!
      let entry = SimpleEntry(
        date: entryDate,
        episode: episodes[index])
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let episode: MiniEpisode
}

struct RWFreeViewWidgetEntryView: View {
  @Environment(\.widgetFamily) var family
  var entry: Provider.Entry

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        PlayButtonIcon(width: 50, height: 50, radius: 10)
          .unredacted()
        VStack(alignment: .leading) {
          Text(entry.episode.name)
            .font(.headline)
            .fontWeight(.bold)
          if family != .systemSmall {
            HStack {
              Text(entry.episode.released + "  ")
              Text(entry.episode.domain + "  ")
              Text(
                String(
                  entry.episode.difficulty)
                  .capitalized)
            }
          } else {
            Text(entry.episode.released + "  ")
          }
        }
      }
      .foregroundColor(Color(UIColor.label))

      if family != .systemSmall {
        Text(entry.episode.description)
          .lineLimit(2)
      }
    }
    .padding(.horizontal)
    .background(Color.itemBkgd)
    .font(.footnote)
    .foregroundColor(Color(UIColor.systemGray))
    .widgetURL(URL(string: "rwfreeview://\(entry.episode.id)"))
  }
}

@main
struct RWFreeViewWidget: Widget {
  let kind: String = "RWFreeViewWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      RWFreeViewWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("RW Free View")
    .description("View free raywenderlich.com video episodes.")
    .supportedFamilies([.systemMedium])
  }
}

struct RWFreeViewWidget_Previews: PreviewProvider {
  static var previews: some View {
    let view = RWFreeViewWidgetEntryView(
      entry: SimpleEntry(
        date: Date(),
        episode: Provider().sampleEpisode))
    view.previewContext(WidgetPreviewContext(family: .systemSmall))
    view.previewContext(WidgetPreviewContext(family: .systemMedium))
    view.previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
