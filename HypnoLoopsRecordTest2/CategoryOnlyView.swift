//
//  CategoryOnlyView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import SwiftUI

struct CategoryOnlyView: View {
    @State var imageName = "finance"
    @State var categoryName = "Hello"
    
    var body: some View {
       ZStack {
           Image(imageName)
               .resizable()
               .aspectRatio(contentMode: .fill)
               //.foregroundColor(.red)
           
           VStack {
               Spacer()
               Text(categoryName.replacingOccurrences(of: "_", with: " "))
               
                   .foregroundColor(.white)
                   .font(.headline)
                   .padding(.bottom, 30)
           }
       }
       .frame(width: 300, height: 200)
       .cornerRadius(10)
       .shadow(radius: 5)
    }
}

struct CategoryOnlyView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryOnlyView()
    }
}