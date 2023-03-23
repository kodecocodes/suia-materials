/// Copyright (c) 2023 Kodeco
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

struct TextView: View {
  @Binding var font: String
  @Binding var color: Color

  var body: some View {
    VStack {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          fonts
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
      }
      HStack {
        colors
      }
    }
    .frame(maxWidth: .infinity)
    .padding([.top, .bottom])
    .background(Color.primary)
  }

  var fonts: some View {
    ForEach(0..<AppFonts.fonts.count, id: \.self) { index in
      ZStack {
        Circle()
          .foregroundColor(.primary)
          .colorInvert()
        Text("Aa")
          .font(.custom(AppFonts.fonts[index], size: 20))
          .fontWeight(.heavy)
          .foregroundColor(.primary)
      }
      .frame(
        width: AppFonts.fonts[index] == font ? 50 : 40,
        height: AppFonts.fonts[index] == font ? 50 : 40)
      .onTapGesture {
        withAnimation {
          font = AppFonts.fonts[index]
        }
      }
    }
  }

  var colors: some View {
    ForEach(1..<8) { index in
      let currentColor = Color("appColor\(index)")
      ZStack {
        Circle()
          .stroke(Color.white, lineWidth: 1.0)
          .overlay(
            Circle()
              .foregroundColor(color == currentColor ? currentColor : .white))
          .frame(
            width: 44,
            height: 44)
        Circle()
          .stroke(lineWidth: color == currentColor ? 0 : 1)
          .overlay(
            Circle()
              .foregroundColor(currentColor))
          .frame(
            width: color == currentColor ? 50 : 40,
            height: color == currentColor ? 50 : 40)
      }
      .onTapGesture {
        withAnimation {
          color = Color("appColor\(index)")
        }
      }
    }
  }
}

struct TextView_Previews: PreviewProvider {
  static var previews: some View {
    TextView(
      font: .constant("San Fransisco"),
      color: .constant(Color("appColor2")))
  }
}
