//
//  HabitListView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitListView: View {
    
    let store: StoreOf<HabitListFeature>
    
    var body: some View {
        
        NavigationStackStore(
            self.store.scope(
                state: \.path,
                action: {.path($0)})
        ) {
            WithViewStore(self.store, observe: \.habits) { viewStore in
                ScrollView {
                    VStack(spacing: 10) {
                        
                        Text("Today")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            .themedFont(name: .bold, size: .small)
                        
                        
     
                            
                        ForEachStore(
                            self.store.scope(state: \.habits,
                                             action: HabitListFeature.Action.habit(id:action:))
                        ){ habitStore in
                            
                            NavigationLink(state: <#T##P?#>, label: <#T##() -> L#>)
                            HabitView(store: habitStore)
                        }
                        
            
                        Text("Done")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                            .themedFont(name: .bold, size: .small)
                        
                        ForEachStore(
                            self.store.scope(state: \.completedHabits,
                                             action: HabitListFeature.Action.doneHabit(id:action:))
                        ){ habitStore in
                            HabitView(store: habitStore)
                                .opacity(0.4)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                
                                viewStore.send(.addHabitTapped)
                            } label: {
                                Label("Add New habit", systemImage: "pencil.tip.crop.circle.badge.plus")
                            }
                            
                            Divider()
                            Divider()
                            
                            Button {
                                
                                
                            } label: {
                                Label("Settings", systemImage: "gear")
                            }
                            
                            Button {
                                
                                
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            
                            Divider()
                            
                            Button {
                                
                                
                            } label: {
                                Label("Premium", systemImage: "star")
                            }

                            
                        } label: {
                            
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                .background(Color.appBackgroundColor)
                
            }
        } destination: {
            switch $0 {
                
            case .habitDetail:
                CaseLet(
                    /HabitListFeature.Path.State.habitDetail,
                     action: HabitListFeature.Path.Action.habitDetail,
                     then: HabitDetailView.init(store:))
            }
        }
        .sheet(
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
            state: /HabitListFeature.Destination.State.addHabitForm,
            action: HabitListFeature.Destination.Action.addHabitForm
        ) { store in
            AddHabitForm(store: store)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    HabitListView(store: Store(
        initialState: HabitListFeature.State(),
        reducer: { HabitListFeature() }
    ))
}
