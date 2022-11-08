/// Copyright (c) 2022 Kodeco LLC
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

extension WelcomeView {
  static var images: some View {
    ZStack {
      Image("hands")
        .resizedToFill(width: 100, height: 100)
        .clipShape(Circle())
        .offset(x: -88, y: 30)
      Image("exercise")
        .resizedToFill(width: 40, height: 40)
        .clipShape(Circle())
        .offset(x: -54, y: -80)
      Image("head")
        .resizedToFill(width: 20, height: 20)
        .clipShape(Circle())
        .offset(x: -44, y: -40)
      Image("arm")
        .resizedToFill(width: 60, height: 60)
        .clipShape(Circle())
        .offset(x: -133, y: -60)
      Image("step-up")
        .resizedToFill(width: 180, height: 180)
        .clipShape(Circle())
        .offset(x: 74)
    }
    .frame(maxWidth: .infinity, maxHeight: 220)
    .shadow(color: Color("drop-shadow"), radius: 6, x: 5, y: 5)
    .padding(.top, 10)
    .padding(.leading, 20)
    .padding(.bottom, 10)
  }

  static var welcomeText: some View {
    return HStack(alignment: .bottom) {
      VStack(alignment: .leading) {
        Text("Get fit")
          .font(.largeTitle)
          .fontWeight(.black)
          .kerning(2)
        Text("by exercising at home")
          .font(.headline)
          .fontWeight(.medium)
          .kerning(2)
      }
    }
  }
}

struct WelcomeImages_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      WelcomeView.images
      WelcomeView.welcomeText
    }
  }
}
