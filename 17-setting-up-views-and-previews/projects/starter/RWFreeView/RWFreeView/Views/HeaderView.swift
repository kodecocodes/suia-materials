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

import SwiftUI

struct HeaderView: View {
  let count: Int
  @State private var queryTerm = ""
  @State private var sortOn = "popular"

  var body: some View {
    VStack {
      SearchField(queryTerm: $queryTerm)
      HStack {
        Button("Clear all") { }
          .buttonStyle(HeaderButtonStyle())
        Button("iOS & Swift") { }
          .buttonStyle(HeaderButtonStyle())
        Spacer()
      }
      HStack {
        Text("\(count) Tutorials")
        Spacer()
        Picker("", selection: $sortOn) {
          Text("New").tag("new")
          Text("Popular").tag("popular")
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 130)
        .background(Color.gray.opacity(0.8))
      }
      .foregroundColor(Color.white.opacity(0.6))
    }
    .font(.subheadline)
    .foregroundColor(.white)
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .leading)
    .listRowInsets(EdgeInsets())
    .padding()
    .background(Color.topBkgd)
    .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
    .background(Color.listBkgd)
  }
}

struct SearchField: View {
  @Binding var queryTerm: String

  var body: some View {
    ZStack(alignment: .leading) {
      if queryTerm.isEmpty {
        Text("\(Image(systemName: "magnifyingglass")) Search videos")
          .foregroundColor(Color.white.opacity(0.6))
      }
      TextField("", text: $queryTerm)
    }
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color.white.opacity(0.2)))
  }
}

struct HeaderButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      Image(systemName: "xmark")
      configuration.label
    }
    .padding(8)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.white.opacity(0.2))
    )
  }
}

struct HeaderView_Previews: PreviewProvider {
  static var previews: some View {
    HeaderView(count: 42)
      //.preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
  }
}
