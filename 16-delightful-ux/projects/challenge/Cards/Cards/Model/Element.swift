/// Copyright (c) 2020 Razeware LLC
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

protocol CardElement {
  var id: UUID { get }
  var transform: Transform { get set }
}

struct ImageElement: CardElement {
  let id = UUID()
  var transform = Transform()
  var image: UIImage?
  var imageFilename: String?
  var clipShape: AnyShape?
  var clipShapeIndex: Int?

  struct ImageData: Codable {
    var transform: Transform
    var imageFilename: String?
    var clipShapeIndex: Int?

    var imageElement: ImageElement {
      let clipShape: AnyShape?
      if let clipShapeIndex = clipShapeIndex {
        clipShape = clipShapes[clipShapeIndex]
      } else {
        clipShape = nil
      }
      let image: UIImage?
      if let imageName = imageFilename {
        image = UIImage.load(uuid: imageName)
      } else {
        image = nil
      }

      return ImageElement(transform: transform,
                   image: image,
                   imageFilename: imageFilename,
                   clipShape: clipShape,
                   clipShapeIndex: clipShapeIndex)
    }
  }
  var data: ImageData {
    ImageData(transform: transform,
              imageFilename: imageFilename,
              clipShapeIndex: clipShapeIndex)
  }
}

struct TextElement: CardElement {
  let id = UUID()
  var transform = Transform()
  var text: String = ""
  var textColor: Color = .primary

  struct TextData: Codable {
    var transform: Transform
    var text: String
    var textColor: [CGFloat]

    var textElement: TextElement {
      TextElement(transform: transform,
                  text: text,
                  textColor: Color.color(components: textColor))
    }
  }
  var data: TextData {
    TextData(transform: transform,
             text: text,
             textColor: textColor.colorComponents())
  }
}
