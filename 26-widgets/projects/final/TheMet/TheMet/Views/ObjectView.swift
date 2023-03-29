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

struct ObjectView: View {
  let object: Object

  var body: some View {
    VStack {
      if let url = URL(string: object.objectURL) {
        Link(destination: url) {
          WebIndicatorView(title: object.title)
            .multilineTextAlignment(.leading)
            .font(.callout)
            .frame(minHeight: 44)
          // add these four modifiers
            .padding()
            .background(Color.metBackground)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
      } else {
        Text(object.title)
          .multilineTextAlignment(.leading)
          .font(.callout)
          .frame(minHeight: 44)
      }

      if object.isPublicDomain {
        AsyncImage(url: URL(string: object.primaryImageSmall)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        } placeholder: {
          PlaceholderView(note: "Display image here")
        }
      } else {
        PlaceholderView(note: "Not in public domain. URL not valid.")
      }

      Text(object.creditLine)
        .font(.caption)
        .padding()
        .background(Color.metForeground)
        .cornerRadius(10)
    }
    .padding(.vertical)
  }
}

struct ObjectView_Previews: PreviewProvider {
  static var previews: some View {
    ObjectView(
      object:
        Object(
          objectID: 452174,
          title: "Bahram Gur Slays the Rhino-Wolf",
          creditLine: "Gift of Arthur A. Houghton Jr., 1970",
          objectURL: "https://www.metmuseum.org/art/collection/search/452174",
          isPublicDomain: true,
          primaryImageSmall: "https://images.metmuseum.org/CRDImages/is/original/DP107178.jpg"))
  }
}
