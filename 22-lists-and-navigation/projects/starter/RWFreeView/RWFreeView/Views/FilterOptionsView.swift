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

  @State private var selected1 = false  // iOS
  @State private var selected2 = false  // Android
  @State private var selected3 = false  // Unity
  @State private var selected5 = false  // macOS
  @State private var selected8 = false  // SSS
  @State private var selected9 = false  // Flutter

  @State private var selectedB = false  // Beginner
  @State private var selectedI = false  // Intermediate
  @State private var selectedA = false  // Advanced

  var body: some View {
    ZStack(alignment: .topTrailing) {
      HStack {
        Spacer()
        Button(
          action: {
            presentationMode.wrappedValue.dismiss()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
          }) {
          Image(systemName: "xmark")
            .font(.title3)
            .foregroundColor(Color(UIColor.label))
            .padding()
            .background(
              Circle().fill((Color.closeBkgd))
          )
        }
        .padding([.top, .trailing])
      }
      VStack {
        Text("Filters")
          .font(.title2)
          .fontWeight(.semibold)
          .padding()
        List {
          VStack(alignment: .leading) {
            Text("Platforms")
              .font(.title2)
              .padding(.bottom)
            VStack(alignment: .leading) {
              AdaptingStack {
                Button("iOS & Swift") { selected1.toggle() }
                  .buttonStyle(FilterButtonStyle(selected: selected1, width: nil))
                Button("Android & Kotlin") { selected2.toggle() }
                  .buttonStyle(FilterButtonStyle(selected: selected2, width: nil))
                Button("macOS") { selected5.toggle() }
                  .buttonStyle(FilterButtonStyle(selected: selected5, width: nil))
              }
              AdaptingStack {
                Button("Server-Side Swift") { selected8.toggle() }
                  .buttonStyle(FilterButtonStyle(selected: selected8, width: nil))
                Button("Unity") { selected3.toggle() }
                  .buttonStyle(FilterButtonStyle(selected: selected3, width: nil))
                Button("Flutter") { selected9.toggle() }
                  .buttonStyle(FilterButtonStyle(selected: selected9, width: nil))
              }
              .padding(.bottom)
            }
          }
          VStack(alignment: .leading) {
            Text("Difficulty")
              .font(.title2)
              .padding(.vertical)
            AdaptingStack {
              Button("Beginner") { selectedB.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selectedB, width: nil))
              Button("Intermediate") { selectedI.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selectedI, width: nil))
              Button("Advanced") { selectedA.toggle() }
                .buttonStyle(FilterButtonStyle(selected: selectedA, width: nil))
            }
            .padding(.bottom)
          }
        }
        Spacer()
        HStack {
          Button("Clear All") { }
            .buttonStyle(FilterButtonStyle(selected: false, width: 160))
          Button("Apply") {
            presentationMode.wrappedValue.dismiss()
          }
          .buttonStyle(FilterButtonStyle(selected: true, width: 160))
        }
        .padding(.bottom)
        .font(.title2)
      }
    }
  }
}

struct FilterButtonStyle: ButtonStyle {
  let selected: Bool
  let width: CGFloat?

  func makeBody(configuration: Self.Configuration)
  -> some View {
    configuration.label
      .foregroundColor(.white)
      .frame(width: width)
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
