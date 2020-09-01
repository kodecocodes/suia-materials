///// Copyright (c) 2020 Razeware LLC
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

struct Chevron: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines([
        .zero,
        CGPoint(x: rect.width * 0.75, y: 0),
        CGPoint(x: rect.width, y: rect.height * 0.5),
        CGPoint(x: rect.width * 0.75, y: rect.height),
        CGPoint(x: 0, y: rect.height),
        CGPoint(x: rect.width * 0.25, y: rect.height * 0.5)
      ])
      path.closeSubpath()
    }
  }
}

struct Diamond: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      let width = rect.width
      let height = rect.height
      
      path.addLines( [
        CGPoint(x: width / 2, y: 0),
        CGPoint(x: width, y: height / 2),
        CGPoint(x: width / 2, y: height),
        CGPoint(x: 0, y: height / 2)
      ])
      path.closeSubpath()
    }
  }
}

struct Heart: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      let width = rect.width
      let height = rect.height
      
      path.move(to: CGPoint(x: width * 0.5, y: height * 0.33))
      path.addCurve(to: CGPoint(x: width * 0.76, y: height * 0.158),
                    control1: CGPoint(x: width * 0.51, y: height * 0.34),
                    control2: CGPoint(x: width * 0.6, y: height * 0.09))
      path.addCurve(to: CGPoint(x: width * 0.8, y: height * 0.568),
                    control1: CGPoint(x: width * 0.92, y: height * 0.23),
                    control2: CGPoint(x: width * 0.85, y: height * 0.49))
      path.addCurve(to: CGPoint(x: width * 0.51, y: height * 0.86),
                    control1: CGPoint(x: width * 0.75, y: height * 0.65),
                    control2: CGPoint(x: width * 0.51, y: height * 0.86))
      path.addCurve(to: CGPoint(x: width * 0.24, y: height * 0.57),
                    control1: CGPoint(x: width * 0.51, y: height * 0.87),
                    control2: CGPoint(x: width * 0.3, y: height * 0.68))
      path.addCurve(to: CGPoint(x: width * 0.28, y: height * 0.158),
                    control1: CGPoint(x: width * 0.18, y: height * 0.46),
                    control2: CGPoint(x: width * 0.12, y: height * 0.21))
      path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.33),
                    control1: CGPoint(x: width * 0.44, y: height * 0.1),
                    control2: CGPoint(x: width * 0.5, y: height * 0.33))
      path.closeSubpath()
    }
  }

}
