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
                            Text("No more adds")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .semiBold, size: .title)
                            
                            Text("Enjoy this application without seeing anny advertisements.")
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
                            Text("Unlimited habit creation")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .semiBold, size: .title)
                            
                            
                            Text("Improve yourself on all areas where needed.")
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
                            Text("Support a solo developer")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .themedFont(name: .semiBold, size: .title)
                            
                            Text("The best way to say thank you!")
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
                        
                        Text("Auto-renews for ")
                            .themedFont(name: .regular, size: .small)
                        
                        Text("\(viewStore.productToPurchase?.displayPrice ?? "")")
                            .themedFont(name: .semiBold, size: .small)
                        
                        Text("/month until canceled.")
                            .themedFont(name: .regular, size: .small)
                    }
                    .padding(.bottom, -15)
                    Button(action: {
                        viewStore.send(.didTapPurchaseProduct)
                    }, label: {
                        ZStack {
                            ButtonView(title: viewStore.isPurchasing ? "laden.." : "Subscribe")
                            
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
