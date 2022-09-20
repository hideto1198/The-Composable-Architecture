//
//  PlanSetView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct PlanSetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) var scenePhase
    let store: Store<TrainerMakeReservationState,TrainerMakeReservationAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    AppHeaderView(title: "予約セット")
                    ZStack {
                        ScrollView {
                            VStack(alignment: .leading) {
                                Group {
                                    TrainerMenuSelectView(viewStore: viewStore)
                                        .padding(.top)
                                    TrainerPlaceSelectView(viewStore: viewStore)
                                        .onTapGesture {
                                            viewStore.send(.ticketAction(.getTicket))
                                        }
                                }
                                .padding(.leading)
                                if viewStore.showReservationDate {
                                    TrainerCalendarSelectView(viewStore: viewStore)
                                        .padding([.horizontal, .top])
                                }
                                if viewStore.showCalendar {
                                    TrainerCalendarView(viewStore: viewStore)
                                        .frame(width: bounds.width)
                                }
                                if viewStore.showTrainerSelector {
                                    TrainerTrainerSelectView(viewStore: viewStore)
                                        .padding([.horizontal, .top])
                                    if viewStore.showTrainer {
                                        TrainerTrainersView(viewStore: viewStore)
                                            .padding(.horizontal)
                                    }
                                }
                                if viewStore.showReservationTime {
                                    TrainerTimeSelectView(store: self.store.scope(state: \.trainerTimescheduleState, action: TrainerMakeReservationAction.trainerTimescheduleAction))
                                        .padding([.horizontal, .top])
                                    
                                }
                                if viewStore.trainerTimescheduleState.showTimeSchedule {
                                    TrainerTimescheduleView(viewStore: viewStore)
                                        .frame(width: bounds.width)
                                }
                                if !viewStore.inputReasonState.reasons.isEmpty {
                                    Button(
                                        action: {
                                            viewStore.send(.onTapAddButton, animation: .easeInOut)
                                        }
                                    ){
                                        ButtonView(text: "追加")
                                    }
                                }
                            }
                            Spacer()
                        }
                        TrainerMakeReservationCheckButtonView(viewStore: viewStore)
                    }
                    .sheet(isPresented: viewStore.binding(\.$isSheet)) {
                        TrainerMakeReservationListView(store: self.store)
                    }
                }
                if viewStore.trainerTimescheduleState.showSetPlan {
                    InputReasonView(viewStore: viewStore)
                }
            }
            .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onEnded{ value in
                        if value.startLocation.x <= bounds.width * 0.09 && value.startLocation.x * 1.1 < value.location.x{
                            withAnimation(){
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
            )
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    viewStore.send(.ticketAction(.getTicket))
                default:
                    return
                }
            }

        }
    }
}

struct PlanSetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanSetView(store: Store(initialState: TrainerMakeReservationState(),
                                 reducer: trainerMakeReservationReducer,
                                 environment: .live))
    }
}
