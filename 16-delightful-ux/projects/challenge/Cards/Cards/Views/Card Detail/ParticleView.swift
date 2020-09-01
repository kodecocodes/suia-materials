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

struct ParticleView: View {
  struct Particle: Identifiable {
    var id = UUID()
    let image: Image
    var transforms: [Transform] = []
  }
  @State var particles: [Particle] = []
  @State var newParticle = true
  @State var particleIndex: Int = 0
  @State var counter = 0
  var particleImage: Image?
  
  var body: some View {
    let dragGesture = DragGesture(minimumDistance: 0)
      .onChanged { value in
        if let particleImage = particleImage {
          if newParticle {
            particles.append(Particle(image: particleImage))
            particleIndex = particles.count - 1
            newParticle = false
          }
        }
        // drop a particle every few drags to spread them out
        // this could be a slider on the particle picker
        if counter % 5 == 0 {
        let offset = CGSize(width: value.location.x, height: value.location.y)
        particles[particleIndex].transforms.append(Transform(size: CGSize(width: 20, height: 20),
                                    scale: CGFloat.random(in: 0.2...2.0), rotation: Angle.degrees(Double.random(in: 0...360)),
                                    offset: offset))
        }
        counter += 1
      }
      .onEnded { _ in
        newParticle = true
        counter = 0
      }
    
    return ZStack {
      if particleImage == nil {
        EmptyView()
      } else {
        Color.yellow
          .opacity(0.01)
          .edgesIgnoringSafeArea(.all)
          .gesture(dragGesture)
      }
      ForEach(particles) { particle in
        ForEach(0..<particle.transforms.count, id: \.self) { index in
          particle.image
            // this could be a selection on the particle picker
            .foregroundColor(.white)
            .blendMode(.colorDodge)
            .scaleEffect(particle.transforms[index].scale)
            .rotationEffect(particle.transforms[index].rotation)
            .position(CGPoint(x: particle.transforms[index].offset.width,
                              y: particle.transforms[index].offset.height))
        }
      }
    }
  }
}

struct ParticleView_Previews: PreviewProvider {
  @State static private var particleImage = Image(systemName: "star")
  
  static var previews: some View {
    NavigationView {
      ZStack {
        Color.red
        ParticleView(particleImage: particleImage)
      }
      .edgesIgnoringSafeArea(.all)
    }
  }
}
