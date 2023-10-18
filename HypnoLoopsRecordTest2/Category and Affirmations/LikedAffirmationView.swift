//
//  LikedAffirmationView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import SwiftUI
import Combine

struct LikedAffirmationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CategoryViewModel
    @Binding var selectedAffirmation: String?
    
    var body: some View {
        ZStack {
            Image("oceanBG")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                        print("cancel")
                    } label: {
                        Text("Cancel")
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 60)
                
                Text("Liked Affirmations:")
                    .foregroundStyle(Color("ringDarkBlue"))
                    .padding()
                    .font(.title)
                ForEach(viewModel.likedAffirmations, id: \.id) { affirmation in
                    AffirmationRow(viewModel: viewModel, affirmation: affirmation)
                        .onTapGesture {
                            selectedAffirmation = affirmation.affirmation
                            dismiss()
                              }
                }
            }
            .padding(.top, 15)
        }
        .onAppear {
            print("Liked affirmations view appeared with \(viewModel.likedAffirmations.count) liked affirmations")
        }
        .navigationTitle("Liked Affirmations")
    }
}

