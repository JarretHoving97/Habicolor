//
//  NotebookView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 22/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct NotebookView: View {
    
    let store: StoreOf<NotebookFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            ZStack {
                ScrollView {
                    VStack {
                        Text("")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
    
                ZStack {
                    Button {
                        viewStore.send(.addNewNotePressed)
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .tint(.white)
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(Color.primaryColor)
                    .clipShape(
                        Circle()
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 17))
                
          
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .background(Color.appBackground)
            
            .sheet(
                store: self.store.scope(state: \.$destination, action: { .destination($0)}),
                state: /NotebookFeature.Destination.State.addNoteFeature,
                action: NotebookFeature.Destination.Action.addNoteFeature
            ) { store in
                
                AddNoteView(store: store)
                    .interactiveDismissDisabled()
            }
            
        }
    }
}

#Preview {
    NotebookView(
        store: Store(
            initialState: NotebookFeature.State(),
            reducer: { NotebookFeature() }
        )
    )
}
