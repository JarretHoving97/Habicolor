//
//  TabBarView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 04/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    
    let store: StoreOf<TabbarFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: \.currentTab) { viewStore in
            
            ZStack {
                Group {
                    if viewStore.state == .habits {
                        // define views
                        HabitListView(
                            store: self.store.scope(
                                state: \.habitList,
                                action: TabbarFeature.Action.habitList
                            )
                        )
                    }
                    
                    if viewStore.state == .logbook {
                        Text("Logbook")
                    }
                    
                    if viewStore.state == .settings {
                        
                        SettingsListView(
                            store: self.store.scope(
                                state: \.settings,
                                action: TabbarFeature.Action.settings
                            )
                        )
                    }
                }
                .padding(.bottom, 20)
   
      
                HStack {
                    
                    Button {
                        viewStore.send(.didChangeTab(.habits), animation: .interactiveSpring)
                    } label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .tint(viewStore.state == .habits ? .sparkleColor : .gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.didChangeTab(.logbook), animation: .interactiveSpring)
                    } label: {
                        Image(systemName: "book.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .tint(viewStore.state == .logbook ? .sparkleColor : .gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.didChangeTab(.settings), animation: .interactiveSpring)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .tint(viewStore.state == .settings ? .sparkleColor : .gray)
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
                .background(Color.appBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
                .shadow(color: .shadowColor, radius: 25, x: 0, y: 25)
            }
            .background(Color.appBackgroundColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    TabBarView(store: Store(
        initialState: TabbarFeature.State(
            currentTab: .habits, // init current selection
            habitList: HabitListFeature.State(),
            settings: SettingsFeature.State()
        ),
        /* add Log book initialization */
        reducer: { TabbarFeature()
            }
        )
    )
}
