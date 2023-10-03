//
//  CategoryView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import SwiftUI
import Combine

struct CategoryView: View {
    @ObservedObject var viewModel: CategoryViewModel

        var body: some View {
            NavigationView {
                ZStack {
                    Image("oceanBG")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.categories) { category in
                                let lowercase = category.title.localizedLowercase
                
                                NavigationLink(destination: AffirmationView(viewModel: viewModel, category: category)) {
                                    CategoryOnlyView(imageName: lowercase, categoryName: category.title)
                                        .padding()
                                }
                                
                            }
                        }
                    }
                }
//                List {
//                    ForEach(viewModel.categories) { category in
//                        Section(header: Text(category.title)) {
//                            ForEach(category.affirmations, id: \.id) { affirmation in
//                                AffirmationRow(affirmation: affirmation)
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Categories")
            }
            
        }
    }

//struct AffirmationRow: View {
//    @ObservedObject var affirmation: Affirmation
//    
//    var body: some View {
//        HStack {
//            Text(affirmation.affirmation)
//            Spacer()
//            Button(action: {
//                affirmation.liked.toggle()
//            }) {
//                Image(systemName: affirmation.liked ? "heart.fill" : "heart")
//                    .foregroundColor(affirmation.liked ? .red : .gray)
//            }
//            .buttonStyle(BorderlessButtonStyle())
//        }
//    }
//}


//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}
