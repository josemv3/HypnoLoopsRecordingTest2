//
//  AffirmationView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import SwiftUI

struct AffirmationView: View {
    var category: Category
    
    var body: some View {
        List(category.affirmations) { affirmation in
            AffirmationRow(affirmation: affirmation)
        }
    }
}

struct AffirmationRow: View {
    @ObservedObject var affirmation: Affirmation
    
    var body: some View {
        HStack {
            Text(affirmation.affirmation)
            Spacer()
            Button(action: {
                affirmation.liked.toggle()
            }) {
                Image(systemName: affirmation.liked ? "heart.fill" : "heart")
                    .foregroundColor(affirmation.liked ? .red : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

//struct AffirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AffirmationView()
//    }
//}
