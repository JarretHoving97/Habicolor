//
//  AddNoteView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 10/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct AddNoteView: View {
    
    @State private var text: String = "Hoe ging het vandaag?"
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 17) {
                
                HStack {
                    ChoosteHealthTemplateView(
                        store: Store(
                            initialState: ChooseHealthTemplateFeature.State(
                                template: .init(
                                    template: .none
                                )
                            ),
                            reducer: { ChooseHealthTemplateFeature() }
                        )
                    )
                    
                    Spacer()
                }
                
                // TODO: Make text editor feature
                VStack {
                    
                    TextEditor(text: $text)
                        
                        .themedFont(name: .regular, size: .regular)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(Color.appTextColor)
                        .frame(minHeight: 40)
                        .background(Color.clear)
                    
                    
                }
                .padding(EdgeInsets(top: -10, leading: 28, bottom: 0, trailing: 17))
                
                
            }
            .padding(EdgeInsets(top: 20, leading: 17, bottom: 0, trailing: 17))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                
                Button {
                    
                } label: {
                    Text("Annuleer")
                        .tint(.appTextColor)
                        .themedFont(name: .regular, size: .regular)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    
                } label: {
                    
                    Text("Toevoegen")
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: 4, leading: 20, bottom: 3, trailing: 20))
                        .themedFont(name: .bold, size: .small)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.primaryColor)
                        )
                }
            }
        }
        .background(Color.appBackgroundColor)
    }
}


#Preview {
    NavigationStack {
        AddNoteView()
            .navigationBarTitleDisplayMode(.inline)
    }
}
