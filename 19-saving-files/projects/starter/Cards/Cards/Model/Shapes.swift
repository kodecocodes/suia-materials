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

enum Shapes {
  static let shapes: [AnyShape] = [
    AnyShape(Circle()), AnyShape(Rectangle()),
    AnyShape(RoundedRectangle(cornerRadius: 25.0)),
    AnyShape(Heart()), AnyShape(Lens()),
    AnyShape(Chevron()),
    AnyShape(Cone()), AnyShape(Cloud()),
    AnyShape(Diamond()),
    AnyShape(Polygon(sides: 6)),
    AnyShape(Polygon(sides: 8))
  ]
}

struct Shapes_Previews: PreviewProvider {
  static let currentShape = Lens()

  static var previews: some View {
    currentShape
      .stroke(
        Color.primary,
        style: StrokeStyle(lineWidth: 10, lineJoin: .round))
      .padding()
      .aspectRatio(1, contentMode: .fit)
      .background(Color.yellow)
      .previewLayout(.sizeThatFits)
  }
}

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    let width = rect.width
    let height = rect.height
    var path = Path()
    path.addLines([
      CGPoint(x: width * 0.13, y: height * 0.2),
      CGPoint(x: width * 0.87, y: height * 0.47),
      CGPoint(x: width * 0.4, y: height * 0.93)
    ])
    path.closeSubpath()
    return path
  }
}

struct Cone: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let radius = min(rect.midX, rect.midY)
    path.addArc(
      center: CGPoint(x: rect.midX, y: rect.midY),
      radius: radius,
      startAngle: Angle(degrees: 0),
      endAngle: Angle(degrees: 180),
      clockwise: true)
    path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
    path.addLine(to: CGPoint(x: rect.midX + radius, y: rect.midY))
    path.closeSubpath()
    return path
  }
}

struct Lens: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: 0, y: rect.midY))
    path.addQuadCurve(
      to: CGPoint(x: rect.width, y: rect.midY),
      control: CGPoint(x: rect.midX, y: 0))
    path.addQuadCurve(
      to: CGPoint(x: 0, y: rect.midY),
      control: CGPoint(x: rect.midX, y: rect.height))
    path.closeSubpath()
    return path
  }
}

struct Heart: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: rect.midX, y: rect.maxY ))
    path.addCurve(
      to: CGPoint(x: rect.minX, y: rect.height * 0.25),
      control1: CGPoint(x: rect.midX * 0.7, y: rect.height * 0.9),
      control2: CGPoint(x: rect.minX, y: rect.midY))
    path.addArc(
      center: CGPoint(
        x: rect.width * 0.25,
        y: rect.height * 0.25),
      radius: (rect.width * 0.25),
      startAngle: Angle(radians: .pi),
      endAngle: Angle(radians: 0),
      clockwise: false)
    path.addArc(
      center: CGPoint(
        x: rect.width * 0.75,
        y: rect.height * 0.25),
      radius: (rect.width * 0.25),
      startAngle: Angle(radians: .pi),
      endAngle: Angle(radians: 0),
      clockwise: false)
    path.addCurve(
      to: CGPoint(x: rect.midX, y: rect.height),
      control1: CGPoint(x: rect.width, y: rect.midY),
      control2: CGPoint(x: rect.midX * 1.3, y: rect.height * 0.9))
    path.closeSubpath()
    return path
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

struct Cloud: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    let width = rect.width
    let height = rect.height
    path.move(to: CGPoint(x: width * 0.2, y: height * 0.2))
    path.addQuadCurve(
      to: CGPoint(x: width * 0.6, y: height * 0.1 ),
      control: CGPoint(x: width * 0.32, y: height * -0.12))
    path.addQuadCurve(
      to: CGPoint(x: width * 0.85, y: height * 0.2 ),
      control: CGPoint(x: width * 0.8, y: height * 0.05))
    path.addQuadCurve(
      to: CGPoint(x: width * 0.9, y: height * 0.6 ),
      control: CGPoint(x: width * 1.1, y: height * 0.35))
    path.addQuadCurve(
      to: CGPoint(x: width * 0.65, y: height * 0.9 ),
      control: CGPoint(x: width * 1, y: height * 0.95))
    path.addQuadCurve(
      to: CGPoint(x: width * 0.15, y: height * 0.7 ),
      control: CGPoint(x: width * 0.2, y: height * 1.1))
    path.addQuadCurve(
      to: CGPoint(x: width * 0.2, y: height * 0.2 ),
      control: CGPoint(x: width * -0.15, y: height * 0.45))
    path.closeSubpath()
    return path
  }
}

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

struct Polygon: Shape {
  let sides: Int

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let radius = min(rect.midX, rect.midY)
    let angle = CGFloat.pi * 2 / CGFloat(sides)
    let points: [CGPoint] = (0..<sides).map { index in
      let currentAngle = angle * CGFloat(index)
      let pointX = radius * cos(currentAngle) + radius
      let pointY = radius * sin(currentAngle) + radius
      return CGPoint(x: pointX, y: pointY)
    }
    path.move(to: points[0])
    for i in 1..<points.count {
      path.addLine(to: points[i])
    }
    path.closeSubpath()
    return path
  }
}
