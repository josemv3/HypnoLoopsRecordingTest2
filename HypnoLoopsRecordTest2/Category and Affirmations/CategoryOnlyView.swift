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
               //Spacer()
               Text(categoryName.replacingOccurrences(of: "_", with: " "))
               
                   .foregroundColor(.white)
                   .font(.headline)
                   //.padding(.top, 150)
                   //.padding(.bottom, 30)
                  
                   .padding(8)
           }
           
           //.frame(maxWidth: .infinity , maxHeight: .infinity)
           .background(Color.white.opacity(0.3))
           .overlay {
               RoundedRectangle(cornerRadius: 5)
                   .stroke(Color.white, lineWidth: 2)
           }
           .padding(.top, 150)
           .padding(.bottom, 30)
       }
       .frame(width: 340, height: 200)
       .cornerRadius(10)
       .shadow(radius: 5)
       .frame(alignment: .center)
    }
}

struct CategoryOnlyView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryOnlyView()
    }
}
