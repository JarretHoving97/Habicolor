//
//  SubscribeView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 17/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct SubscribeView: View {
    
    let store: StoreOf<SubscriptionFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewStore.send(.dismissTapped)
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 20))
                .tint(Color.appText)
                
                Spacer()
                VStack {
                    
                    HStack(spacing: 20) {
                        
                        Text("Habicolor Plus")
                            .themedFont(name: .regular, size: .large)
                     
                        Image(systemName: "sparkles")
                            .resizable()
                            .frame(width: 20, height: 24, alignment: .leading)
                            .foregroundStyle(Color("sparkle_color"))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    .padding(
                        EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 20)
                    )

                    
                    HStack(spacing: 20) {
                        Text("🚫")
                            .themedFont(name: .regular, size: .large)
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                        
                        VStack {
                            Text(trans("subscription_view_no_more_adds_title_label"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .semiBold, size: .title)
                                .minimumScaleFactor(0.4)
                            
                            // TODO: Translations
                            Text(trans("subscription_view_no_more_adds_description_label"))
                                .multilineTextAlignment(.leading)
                                .themedFont(name: .regular, size: .small)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2, reservesSpace: true)
                                .foregroundStyle(Color.appTextColor.opacity(0.5))
                        }
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                    
                    HStack(spacing: 20) {
                        Text("♾️")
                            .themedFont(name: .regular, size: .large)
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                        
                        VStack {
                            Text(trans("subscription_view_unlimited_habit_creation_title_label"))
                                .minimumScaleFactor(0.4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .semiBold, size: .title)
                            
                            // TODO: Translations
                            Text(trans("subscription_view_unlimited_habit_creation_description_label"))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .regular, size: .small)
                                .lineLimit(2, reservesSpace: true)
                                .foregroundStyle(Color.appTextColor.opacity(0.5))
                        }
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                    
                    HStack(spacing: 20) {
                        Text("🫶🏼")
                            .themedFont(name: .regular, size: .large)
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                        
                        VStack {
       
                            Text(trans("subscription_view_support_solo_developer_title_label"))
                                .minimumScaleFactor(0.4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .semiBold, size: .title)
                            
                
                            Text(trans("subscription_view_suppot_solo_developer_description_label"))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .regular, size: .small)
                                .lineLimit(2, reservesSpace: true)
                                .foregroundStyle(Color.appTextColor.opacity(0.5))
                        }
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                }
                Spacer()
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(trans("subscription_view_auto_renews_label"))
                            .themedFont(name: .regular, size: .small)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        Text("\(viewStore.productToPurchase?.displayPrice ?? "")")
                            .themedFont(name: .semiBold, size: .small)
                            .minimumScaleFactor(0.4)
                        Text(trans("subscription_view_auto_renews_until_canceled_label"))
                            .themedFont(name: .regular, size: .small)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: -15, trailing: 20))
                    Button(action: {
                        viewStore.send(.didTapPurchaseProduct)
                    }, label: {
                        ZStack {
        
                            ButtonView(title: viewStore.isPurchasing ? .transStandards(for: .defaultLoadingLabel) : trans("subscription_view_subscribe_buton_label"))
                            
                            if viewStore.isPurchasing {
                                ProgressView()
                                    .tint(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                            }
                        }
                        .frame(height: 60)
                    })
                    .padding(20)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .alert(
                store: self.store.scope(
                    state: \.$destination,
                    action:  { .destination($0)}),
                state: /SubscriptionFeature.Destination.State.alert,
                action: SubscriptionFeature.Destination.Action.alert
            )
            .task {
                viewStore.send(.fetchProducts)
            }
        }
    }
}

#Preview {
    SubscribeView(
        store: Store(
            initialState: SubscriptionFeature.State(),
            reducer: { SubscriptionFeature(appStoreClient: StoreKitClient()
                )
            }
        )
    )
}
