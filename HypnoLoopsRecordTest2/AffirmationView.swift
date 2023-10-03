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
            
            List(category.affirmations) { affirmation in
                AffirmationRow(viewModel: viewModel, affirmation: affirmation)
            }
            
        }
        //.background(Color.black.opacity(0.8))
    }
}

struct AffirmationRow: View {
    @ObservedObject var viewModel: CategoryViewModel
    @ObservedObject var affirmation: Affirmation
    
    var body: some View {
        HStack {
            Text(affirmation.affirmation)
            Spacer()
            Button(action: {
                affirmation.liked.toggle()
                viewModel.saveLikedAffirmations()
            }) {
                Image(systemName: affirmation.liked ? "heart.fill" : "heart")
                    .foregroundColor(affirmation.liked ? .red : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()                // Padding around the content inside the HStack
        .background(Color.blue.opacity(0.5))  // Blue background
                .foregroundColor(.white) // White text color
                .border(Color.white, width: 1)  // White border
                .cornerRadius(0.5)
                .padding(.vertical, 5)
                
        
    
    }
}

//struct AffirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AffirmationView()
//    }
//}
