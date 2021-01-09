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

struct FilterOptionsView: View {
  @Environment(\.presentationMode) var presentationMode

  @State var selected1 = false  // iOS
  @State var selected2 = false  // Android
  @State var selected3 = false  // Unity
  @State var selected5 = false  // macOS
  @State var selected8 = false  // SSS
  @State var selected9 = false  // Flutter

  @State var selectedB = false  // Beginner
  @State var selectedI = false  // Intermediate
  @State var selectedA = false  // Advanced

  var body: some View {
    NavigationView {
      Form {
        Section {
          Text("Platforms")
            .font(.title)
          VStack(alignment: .leading) {
            HStack {
              Button("iOS & Swift") { selected1.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selected1))
              Spacer()
              Button("Android & Kotlin") { selected2.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selected2))
            }
            HStack {
              Button("macOS") { selected5.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selected5))
              Spacer()
              Button("Flutter") { selected9.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selected9))
            }
            HStack {
              Button("Server-Side Swift") { selected8.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selected8))
              Spacer()
              Button("Unity") { selected3.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selected3))
            }
          }
        }
        Section {
          Text("Difficulty")
            .font(.title)
          HStack(spacing: 10) {
            Button("Beginner") { selectedB.toggle() }
              .buttonStyle(FilterButtonStyle(selected: selectedB))
            Button("Intermediate") { selectedI.toggle() }
              .buttonStyle(FilterButtonStyle(selected: selectedI))
            Button("Advanced") { selectedA.toggle() }
              .buttonStyle(FilterButtonStyle(selected: selectedA))
          }
        }
      }
      .navigationBarTitle(Text("Filters"), displayMode: .inline)
      .toolbar {
        ToolbarItem {
          // swiftlint:disable:next multiple_closures_with_trailing_closure
          Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "xmark.circle")
          }
        }
      }
    }
    //.buttonStyle(FilterButtonStyle(selected: false))
  }
}

struct FilterButtonStyle: ButtonStyle {
  let selected: Bool

  func makeBody(configuration: Self.Configuration)
  -> some View {
    configuration.label
      .foregroundColor(.white)
      .padding(7)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(selected ? Color.greenButton : Color.grayButton)
      )
  }
}

struct FilterOptionsView_Previews: PreviewProvider {
  static var previews: some View {
    FilterOptionsView()
  }
}
