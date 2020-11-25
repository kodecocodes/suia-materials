//
//  RatingView.swift
//  Scratch
//
//  Created by Audrey Tam on 18/11/20.
//

import SwiftUI

struct RatingView: View {
  @Binding var rating: Int

  var label = ""
  var maximumRating = 5

  var offImage: Image?
  var onImage = Image(systemName: "waveform.path.ecg")

  var offColor = Color.gray
  var onColor = Color.red

  var body: some View {
    HStack {
      ForEach(1 ..< maximumRating + 1) { number in
        //self.image(for: number)
        self.onImage
          .foregroundColor(number > self.rating ? self.offColor : self.onColor)
          .onTapGesture {
            self.rating = number
          }
      }
    }
    .font(.largeTitle)
  }

  func image(for number: Int) -> some View {
    if number > rating {
      return onImage.foregroundColor(offColor)
    } else {
      return onImage.foregroundColor(onColor)
    }
  }
}

struct Rating_Previews: PreviewProvider {
  static var previews: some View {
    RatingView(rating: .constant(4))
      .previewLayout(.sizeThatFits)
  }
}
