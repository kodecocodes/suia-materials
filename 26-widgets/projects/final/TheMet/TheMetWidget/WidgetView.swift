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

import SwiftUI
import WidgetKit

struct WidgetView: View {
  let entry: Provider.Entry
  var body: some View {
    VStack {
      Text("The Met")  // 1
        .font(.headline)
        .padding(.top)
      Divider()  // 2

      if !entry.object.isPublicDomain {  // 3
        WebIndicatorView(title: entry.object.title)
          .padding()
          .background(Color.metBackground)
          .foregroundColor(.white)
      } else {
        DetailIndicatorView(title: entry.object.title)
          .padding()
          .background(Color.metForeground)
      }
    }
    .truncationMode(.middle)  // 4
    .fontWeight(.semibold)
    .widgetURL(URL(string: "themet://\(entry.object.objectID)"))
  }
}

struct WidgetView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WidgetView(
        entry: SimpleEntry(
          date: Date(),
          object: Object.sample(isPublicDomain: true)))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
      WidgetView(
        entry: SimpleEntry(
          date: Date(),
          object: Object.sample(isPublicDomain: false)))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
  }
}

struct DetailIndicatorView: View {
  let title: String
  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Text(title)
      Spacer()
      Image(systemName: "doc.text.image.fill")
    }
  }
}
