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

extension ViewState {
  func buttonView(disabled: Bool = false) -> some View {
    let imageName: String
    let text: String
    switch self {
    case .imagePicker:
      imageName = "photo"
      text = "Photos"
    case .colorPicker:
      imageName = "eyedropper"
      text = "Color"
    case .clipShapes:
      imageName = "square.on.circle"
      text = "Shapes"
    case .stickerPicker:
      imageName = "heart.circle"
      text = "Stickers"
    case .particlePicker:
      imageName = "star.fill"
      text = "Particles"
    case .textEntry:
      imageName = "textbox"
      text = "Text"
    default:
      imageName = ""
      text = ""
    }
    
    return VStack {
      ZStack {
        Circle()
          .foregroundColor(disabled ? .gray : .red).opacity(0.3)
        Image(systemName: imageName)
          .padding(10)
      }
      Text(text)
        .font(.caption)
        .fixedSize(horizontal: true, vertical: false)
    }
    .foregroundColor(disabled ? .gray : .black)
    .padding(.top, 15)
    .padding([.leading, .trailing], 5)
  }
}

struct CardViewToolbar: View {
  @Binding var viewState: ViewState?
  let clipShapeDisabled: Bool
  
  var body: some View {
    HStack {
      Button(action: {
        viewState = .imagePicker
      }) {
        ViewState.imagePicker.buttonView()
      }
      Button(action: {
        viewState = .clipShapes
      }) {
        ViewState.clipShapes.buttonView(disabled: clipShapeDisabled)
      }
      .disabled(clipShapeDisabled)
      Button(action: {
        viewState = .colorPicker
      }) {
        ViewState.colorPicker.buttonView()
      }
      Button(action: {
        viewState = .stickerPicker
      }) {
        ViewState.stickerPicker.buttonView()
      }
      Button(action: {
        viewState = .particlePicker
      }) {
        ViewState.particlePicker.buttonView()
      }
      Button(action: {
        viewState = .textEntry
      }) {
        ViewState.textEntry.buttonView()
      }
    }
  }
}

struct DoneBar: View {
  @Binding var particleImage: Image?
  
  var body: some View {
    Button(action: {
      particleImage = nil
    }) {
      HStack {
        Text("Done")
      }
    }
  }
}


struct CardViewToolbar_Previews: PreviewProvider {
  
  @State private static var viewState: ViewState?
  @State private static var clipShapeDisabled = true
  @State private static var particleImage: Image? = Image(systemName: "star")
  static var previews: some View {
    VStack {
      Spacer()
      CardViewToolbar(viewState: $viewState,
                      clipShapeDisabled: clipShapeDisabled)
        .frame(height: 40)
      Spacer()
      DoneBar(particleImage: $particleImage)
      Spacer()
    }
  }
}
