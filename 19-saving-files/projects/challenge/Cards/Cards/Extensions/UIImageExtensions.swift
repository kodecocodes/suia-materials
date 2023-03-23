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

extension UIImage: Transferable {
  public static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { image in
      UIImage(data: image) ?? errorImage
    }
  }

  public static var errorImage: UIImage {
    UIImage(named: "error-image") ?? UIImage()
  }
}

// MARK: - SAVE, LOAD AND DELETE IMAGE FILE
extension UIImage {
  static var minsize = CGSize(width: 300, height: 200)
  static var maxSize = CGSize(width: 1000, height: 1500)

  func save(to filename: String? = nil) -> String {
    // first resize large images
    let image = resizeLargeImage()
    let path: String
    if let filename = filename {
      path = filename
    } else {
      path = UUID().uuidString
    }
    let url = URL.documentsDirectory.appendingPathComponent(path)
    do {
      try image.pngData()?.write(to: url)
    } catch {
      print(error.localizedDescription)
    }
    return path
  }

  static func load(uuidString: String) -> UIImage? {
    guard uuidString != "none" else { return nil }
    let url = URL.documentsDirectory.appendingPathComponent(uuidString)
    if let imageData = try? Data(contentsOf: url) {
      return UIImage(data: imageData)
    } else {
      return nil
    }
  }

  static func remove(name: String?) {
    if let name {
      let url = URL.documentsDirectory.appendingPathComponent(name)
      try? FileManager.default.removeItem(at: url)
    }
  }
}

// MARK: - GET IMAGE SIZE
extension UIImage {
  func initialSize() -> CGSize {
    var width = Settings.defaultElementSize.width
    var height = Settings.defaultElementSize.height

    if self.size.width >= self.size.height {
      width = max(Self.minsize.width, width)
      width = min(Self.maxSize.width, width)
      height = self.size.height * (width / self.size.width)
    } else {
      height = max(Self.minsize.height, height)
      height = min(Self.maxSize.height, height)
      width = self.size.width * (height / self.size.height)
    }
    return CGSize(width: width, height: height)
  }

  static func imageSize(named imageName: String) -> CGSize {
    if let image = UIImage(named: imageName) {
      return image.initialSize()
    }
    return .zero
  }
}

// MARK: - RESIZE IMAGE
extension UIImage {
  func resizeLargeImage() -> UIImage {
    let defaultSize: CGFloat = 1000
    if size.width <= defaultSize ||
      size.height <= defaultSize { return self }

    let scale: CGFloat
    if size.width >= size.height {
      scale = defaultSize / size.width
    } else {
      scale = defaultSize / size.height
    }
    let newSize = CGSize(
      width: size.width * scale,
      height: size.height * scale)
    return resize(to: newSize)
  }

  func resize(to size: CGSize) -> UIImage {
    // UIGraphicsImageRenderer sets scale to device's screen scale
    // change the scale to 1 to get the real image size
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    return UIGraphicsImageRenderer(size: size, format: format).image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
