//
//  AddNoteView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 10/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct AddNoteView: View {
    
    let store: StoreOf<AddNoteFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            NavigationStack {
                ScrollView {
                    
                    VStack(spacing: 17) {
                        HStack {
                            HealthTemplateButtonView(
                                store: store.scope(
                                    state: \.currentTemplateState,
                                    action: AddNoteFeature.Action.currentTemplateState
                                )
                            )
                            Spacer()
                        }
                        
                        
                        // TODO: Make text editor feature
                        VStack {
                            TextEditor(text: .constant("Hoe ging het vandaag?"))
                            
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
                            viewStore.send(.dismissPressed)
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
                .sheet(
                    store: self.store.scope(state: \.$destination, action: { .destination($0)}),
                    state: /AddNoteFeature.Destination.State.chooseTemplateFeatue,
                    action: AddNoteFeature.Destination.Action.chooseTemplateFeatue
                ) { store in
                    
                    TemplateSelectionView(store: store)
                }
            }
 
        }
    }
}


#Preview {
    NavigationStack {
        AddNoteView(
            store: Store(
                initialState: AddNoteFeature.State(
                    currentTemplateState: HealthTemplateButtonFeature.State(
                        template: HealthTemplate(
                            template: .none
                        )
                    )
                ),
                reducer: { AddNoteFeature() }
            )
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}
