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

private struct SplashAnimation: ViewModifier {
  @State private var animating = true
  let finalYPosition: CGFloat
  let delay: Double
  let animation = Animation.interpolatingSpring(
    mass: 0.2,
    stiffness: 80,
    damping: 5,
    initialVelocity: 0.0)

  func body(content: Content) -> some View {
    content
      .offset(y: animating ? -700 : finalYPosition)
      .rotationEffect(
        animating ? .zero
          : Angle(degrees: Double.random(in: -10...10)))
      .animation(animation.delay(delay), value: animating)
      .onAppear {
        animating = false
      }
  }
}

struct SplashScreen: View {
  var body: some View {
    ZStack {
      Color("background")
        .ignoresSafeArea()
      card(letter: "S", color: "appColor1")
        .splashAnimation(finalYposition: 240, delay: 0)
      card(letter: "D", color: "appColor2")
        .splashAnimation(finalYposition: 120, delay: 0.2)
      card(letter: "R", color: "appColor3")
        .splashAnimation(finalYposition: 0, delay: 0.4)
      card(letter: "A", color: "appColor6")
        .splashAnimation(finalYposition: -120, delay: 0.6)
      card(letter: "C", color: "appColor7")
        .splashAnimation(finalYposition: -240, delay: 0.8)
    }
  }

  func card(letter: String, color: String) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25)
        .shadow(radius: 3)
        .frame(width: 120, height: 160)
        .foregroundColor(.white)
      Text(letter)
        .fontWeight(.bold)
        .scalableText()
        .foregroundColor(Color(color))
        .frame(width: 80)
    }
  }
}

struct SplashScreen_Previews: PreviewProvider {
  static var previews: some View {
    SplashScreen()
  }
}

private extension View {
  func splashAnimation(
    finalYposition: CGFloat,
    delay: Double
  ) -> some View {
    modifier(SplashAnimation(
      finalYPosition: finalYposition,
      delay: delay))  }
}
