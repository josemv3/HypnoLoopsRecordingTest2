//
//  AffirmationView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import SwiftUI
import Combine

struct AffirmationView: View {
    @ObservedObject var viewModel: CategoryViewModel
    var category: Category
    
    var body: some View {
            ZStack {
                Image("oceanBG")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                ForEach(category.affirmations, id: \.id) { affirmation in
                        AffirmationRow(viewModel: viewModel, affirmation: affirmation)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    //.background(Color.blue)
                    //.scrollContentBackground(.hidden)
                }
            }
        
        //.background(Color.black.opacity(0.8))
    }
}

struct AffirmationRow: View {
   
    @ObservedObject var viewModel: CategoryViewModel
    @ObservedObject var affirmation: Affirmation
    
    var onSelect: ((String) -> Void)?

    func selectAffirmation(_ string: String) {
        onSelect?(string)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(affirmation.affirmation)
                    .padding(.vertical, 5)
                    .padding(.leading, 5)
                    //.foregroundColor(.white)
                Spacer()
             
                Button(action: {
                    affirmation.liked.toggle()
                    viewModel.saveLikedAffirmations()
                }) {
                    Image(systemName: affirmation.liked ? "heart.fill" : "heart")
                        .foregroundColor(affirmation.liked ? .red : .gray)
                        .padding(.trailing, 5)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.vertical, 5)                // Padding around the content inside the HStack
            .frame(maxWidth: 350 , maxHeight: .infinity)
            .background(Color.white.opacity(0.3))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            }
            .padding(8)
            Divider()
        }
//        .background(Color.blue.opacity(0.5))  // Blue background
//                .foregroundColor(.white) // White text color
//                .border(Color.white, width: 1)  // White border
//                .cornerRadius(0.5)
//                .padding(.vertical, 5)
                
        
    
    }
}

//struct AffirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AffirmationView()
//    }
//}
