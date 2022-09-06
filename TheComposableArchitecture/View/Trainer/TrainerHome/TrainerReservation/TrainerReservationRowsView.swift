//
//  TrainerReservationRowsView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/06.
//

import SwiftUI
import ComposableArchitecture

struct TrainerReservationRowsView: View {
    let viewStore: ViewStore<TrainerReservationState, TrainerReservationAction>
    
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                ForEach(viewStore.details) { detail in
                    TrainerReservationRowView(detail: detail)
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewStore.send(.getGymDetails)
            }
        } else {
            List {
                ForEach(viewStore.details) { detail in
                    TrainerReservationRowView(detail: detail)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct TrainerReservationRowsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerReservationRowsView(viewStore: ViewStore(Store(initialState: TrainerReservationState(),
                                                              reducer: trainerReservationReducer,
                                                              environment: .live)))
    }
}
