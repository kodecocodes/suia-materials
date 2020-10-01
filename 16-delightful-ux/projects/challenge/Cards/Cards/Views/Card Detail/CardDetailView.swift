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

struct CardDetailView: View {
  @EnvironmentObject var model: Model
  
  @Binding var isPresented: Bool
  
  // Modal View Options
  @State private var viewState: ViewState?
  @State private var images: [UIImage] = []
  @State private var stickerImage: UIImage?
  @State private var shapeIndex: Int?
  @State private var particleIndex: Int?
  @State private var particleImage: Image?
  @State private var elementSelected: CardElement?
  @State private var shareImage: UIImage?
  @State private var shouldScreenshot = false
  @State private var textElement = TextElement()
  @Binding var card: Card
  
  init(isPresented: Binding<Bool>, card: Binding<Card>) {
    _isPresented = isPresented
    _card = card
    
    let navAppearance = UINavigationBarAppearance()
    navAppearance.backgroundColor = UIColor(named: "Background")
    navAppearance.shadowColor = .clear
    UINavigationBar.appearance().standardAppearance = navAppearance
   
    let toolbarAppearance = UIToolbarAppearance()
    toolbarAppearance.backgroundColor = UIColor(named: "Background")
    toolbarAppearance.shadowColor = .clear
    UIToolbar.appearance().standardAppearance = toolbarAppearance
  }
  
  
  var body: some View {
    GeometryReader { geometry in
      HStack {
        RenderableView(card: $card,
                       shouldScreenshot: $shouldScreenshot,
                       image: $shareImage) {
          ZStack {
            card.backgroundColor
              .onTapGesture {
                elementSelected = nil
              }
            ElementsView(card: $card,
                         elementSelected: $elementSelected,
                         viewState: $viewState)
            
            ParticleView(particleImage: particleImage)
          }
          .clipped()
          .frame(width: Settings.cardSize.width,
                 height: Settings.cardSize.height)
        }
        .shadow(radius: 30)
        .scaleEffect(cardScale(size: geometry.size))
        .navigationBarTitleDisplayMode(.inline)
        .onDrop(of: [.image], isTargeted: nil) { itemProviders, location in
          if let provider = itemProviders.first {
            if provider.canLoadObject(ofClass: UIImage.self) {
              provider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                  DispatchQueue.main.async {
                    let offsetX = location.x - geometry.size.width / 2
                    let offsetY = location.y - geometry.size.height / 2
                    card.addElement(image: image, offset: CGSize(width: offsetX, height: offsetY))
                  }
                }
              }
            }
            return true
          }
          return false
        }
      }
      .frame(width: geometry.size.width,
             height: geometry.size.height)
    }
    
    
    .background(Color("Background"))


    .toolbar {
      ToolbarItem(placement: .principal) {
        HStack {
          TextField("Enter card name", text: $card.name)
        }
      }
      ToolbarItem(placement: .bottomBar) {
        if particleImage == nil {
          CardViewToolbar(viewState: $viewState,
                          clipShapeDisabled: elementSelected == nil)
        } else {
          HStack {
            Spacer()
            DoneBar(particleImage: $particleImage)
            Spacer()
          }
        }
      }
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: {
          isPresented.toggle()
        }) {
          Text("Save")
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          shouldScreenshot = true
          viewState = .shareSheet
        }) {
          Image(systemName: "square.and.arrow.up")
        }
      }
    }


    .sheet(item: $viewState) { item in
      switch item {
      case .imagePicker:
        ImagePicker(images: $images)
          .onDisappear {
            for image in images {
              card.addElement(image: image)
            }
            images = []
          }
      case .colorPicker:
        ColorPickerView(backgroundColor: $card.backgroundColor)
          .onDisappear {
            card.save()
          }
      case .clipShapes:
        if let element = elementSelected as? ImageElement {
          ClipShapesView(shapeIndex: $shapeIndex,
                         image: element.image)
            .onDisappear {
              if let shapeIndex = shapeIndex,
                 let element = elementSelected {
                card.update(element, shapeIndex: shapeIndex)
              }
              shapeIndex = nil
            }
        }
      case .stickerPicker:
        StickerPicker(stickerImage: $stickerImage)
          .onDisappear {
            if let stickerImage = stickerImage {
              card.addElement(image: stickerImage)
            }
            stickerImage = nil
          }
      case .particlePicker:
        ParticlePicker(particleIndex: $particleIndex)
          .onDisappear {
            if let particleIndex = particleIndex {
              particleImage = Image(systemName: particles[particleIndex])
            }
            particleIndex = nil
          }
      case .textEntry:
        TextEntryView(element: elementSelected, textElement: $textElement)
          .onDisappear {
            if textElement.text != "" {
              if let element = elementSelected {
                card.update(element, textElement: textElement)
              } else {
                card.addTextElement(textElement)
              }
            } else {
              if let element = elementSelected {
                card.remove(element)
              }
            }
            elementSelected = nil
            textElement = TextElement()
          }
      case .shareSheet:
        if let shareImage = shareImage {
          ShareSheetView(activityItems: [shareImage],
                         applicationActivities: nil)
        }
      }
    }
 
  }
  
  func cardScale(size: CGSize) -> CGFloat {
    var scale: CGFloat
    if size.width < size.height {
      scale = size.width / Settings.cardSize.width
    } else {
      scale = size.height / Settings.cardSize.height
    }
    return scale
  }
}

struct CardView_Previews: PreviewProvider {
  @State private static var card = initialCards[0]
  @State private static var isPresented = true
  
  static var previews: some View {
    NavigationView {
      CardDetailView(isPresented: $isPresented, card: $card)
        .environmentObject(Model())
    }
  }
}
