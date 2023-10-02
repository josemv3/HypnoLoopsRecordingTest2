//
//  LikedAffirmationView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import SwiftUI

struct LikedAffirmationView: View {
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        List(viewModel.likedAffirmations) { affirmation in
            AffirmationRow(affirmation: affirmation)
        }
        .navigationTitle("Liked Affirmations")
    }
}


struct LikedAffirmationView_Previews: PreviewProvider {
    static var previews: some View {
        LikedAffirmationView(viewModel: CategoryViewModel())
    }
}
