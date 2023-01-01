//
//  ObjectView.swift
//  TheMet
//
//  Created by Caroline Begbie on 5/8/2022.
//

import SwiftUI

struct ObjectView: View {
  let object: Object

  var body: some View {
    VStack {
      if object.isPublicDomain {
        AsyncImage(url: URL(string: object.primaryImageSmall)){ image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        } placeholder: {
          Color.red
        }
        Text(object.title)
      }
    }
  }
}

//struct ObjectView_Previews: PreviewProvider {
//  static var previews: some View {
//    ObjectView(object: 437133)
//  }
//}
