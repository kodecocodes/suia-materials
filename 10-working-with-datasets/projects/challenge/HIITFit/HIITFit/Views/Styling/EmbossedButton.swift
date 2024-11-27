/// Copyright (c) 2025 Kodeco Inc.
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

enum EmbossedButtonShape {
  case circle, capsule
}

struct EmbossedButtonStyle: ButtonStyle {
  var buttonShape = EmbossedButtonShape.capsule
  var buttonScale = 1.0

  func makeBody(configuration: Configuration) -> some View {
    let shadow = Color.dropShadow
    let highlight = Color.dropHighlight
    return configuration.label
      .padding(10)
      .background(
        GeometryReader { geometry in
          shape(size: geometry.size)
            .foregroundStyle(Color.background)
            .shadow(color: shadow, radius: 1, x: 2, y: 2)
            .shadow(color: highlight, radius: 1, x: -2, y: -2)
            .offset(x: -1, y: -1)
        })
      .scaleEffect(configuration.isPressed ? buttonScale : 1.0)
  }

  @ViewBuilder
  func shape(size: CGSize) -> some View {
    switch buttonShape {
    case .circle:
      Circle()
        .stroke(Color.background, lineWidth: 2)
        .frame(
          width: max(size.width, size.height),
          height: max(size.width, size.height))
        .offset(x: -1)
        .offset(y: -max(size.width, size.height) / 2 +
          min(size.width, size.height) / 2)
    case .capsule:
      Capsule()
        .stroke(Color.background, lineWidth: 2)
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  Button("History") {}
    .fontWeight(.bold)
    .buttonStyle(EmbossedButtonStyle(buttonShape: .circle))
    .padding(40)
}
