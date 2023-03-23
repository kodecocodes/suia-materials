///// Copyright (c) 2022 Kodeco LLC
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

struct IndentView<Content: View>: View {
  var content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    ZStack {
      content
        .background(
          GeometryReader { geometry in
            Circle()
              .inset(by: -4)
              .stroke(Color("background"), lineWidth: 8)
              .shadow(color: Color("drop-shadow").opacity(0.5), radius: 6, x: 6, y: 6)
              .shadow(color: Color("drop-highlight"), radius: 6, x: -6, y: -6)
              .foregroundColor(Color("background"))
              .clipShape(Circle().inset(by: -1))
              .resized(size: geometry.size)
          }
        )
    }
  }
}

private extension View {
  func resized(size: CGSize) -> some View {
    self
      .frame(
        width: max(size.width, size.height),
        height: max(size.width, size.height))
      .offset(y: -max(size.width, size.height) / 2
        + min(size.width, size.height) / 2)
  }
}

struct IndentView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      IndentView {
        Text("5")
          .font(.system(size: 90, design: .rounded))
          .frame(width: 120, height: 120)
      }
      .padding(.bottom, 50)
      IndentView {
        Image(systemName: "hare.fill")
          .font(.largeTitle)
          .foregroundColor(.purple)
          .padding(20)
      }
    }
  }
}
