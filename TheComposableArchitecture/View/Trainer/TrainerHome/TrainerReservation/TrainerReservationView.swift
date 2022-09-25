//
//  TrainerReservationView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/06.
//

import SwiftUI
import ComposableArchitecture

struct TrainerReservationView: View {
    @Environment(\.scenePhase) var scenePhase
    let store: Store<TrainerReservationState, TrainerReservationAction>
    init(store: Store<TrainerReservationState, TrainerReservationAction>) {
        UITableView.appearance().backgroundColor = UIColor.clear
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("本日の予約\(viewStore.details.count)件")
                        Spacer()
                    }
                    TrainerReservationRowsView(viewStore: viewStore)
                    Spacer()
                }
                if viewStore.isLoading {
                    ActivityIndicator()
                }
            }
            .onAppear {
                viewStore.send(.getGymDetails)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    viewStore.send(.getGymDetails)
                    return
                default:
                    return
                }
            }
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onEnded{ value in
                        if (value.startLocation.x - value.location.x ) > 100 {
                        } else if (value.startLocation.x - value.location.x) < -100 {
                        }
                    }
            )
        }
    }
}

struct TrainerReservationView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerReservationView(store: Store(initialState: TrainerReservationState(),
                                            reducer: trainerReservationReducer,
                                            environment: .live))
    }
}
