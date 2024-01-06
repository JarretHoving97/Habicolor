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
        
        WithViewStore(self.store, observe: {$0}) { viewStore in
            
            VStack {
                switch viewStore.currentTab {
                case .habits:
                    // define views
                    HabitListView(
                        store: self.store.scope(
                            state: \.habitList,
                            action: TabbarFeature.Action.habitList
                        )
                    )
                    
                case .logbook:
                    Text("Logbook")
                    
                case .settings:
                    
                    SettingsListView(
                        store: self.store.scope(
                            state: \.settings,
                            action: TabbarFeature.Action.settings
                        )
                    )
                }
                
                Spacer()
                
                
                ZStack {
                    HStack {
                        Button {
                            viewStore.send(.didChangeTab(.habits), animation: .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.25))
                        } label: {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .tint(viewStore.currentTab == .habits ? .sparkleColor : .gray)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewStore.send(.didChangeTab(.logbook), animation: .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.25))
                        } label: {
                            Image(systemName: "book.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .tint(viewStore.currentTab  == .logbook ? .sparkleColor : .gray)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewStore.send(.didChangeTab(.settings), animation: .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.25))
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .tint(viewStore.currentTab == .settings ? .sparkleColor : .gray)
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
                    .background(Color.appBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .shadow(color: .shadowColor, radius: 25, x: 0, y: 25)
                }
      
                .hide(if: !viewStore.showBottomBar)
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottom)
                .background(Color.clear)
                .ignoresSafeArea()
            }
            .background(Color.appBackgroundColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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


// modifier
struct HideViewModifier: ViewModifier {
    let isHidden: Bool
    @ViewBuilder func body(content: Content) -> some View {
        if isHidden {
            EmptyView()
        } else {
            content
        }
    }
}

// Extending on View to apply to all Views
extension View {
    func hide(if isHiddden: Bool) -> some View {
        ModifiedContent(content: self,
                        modifier: HideViewModifier(isHidden: isHiddden)
        )
    }
}
