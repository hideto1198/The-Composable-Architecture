//
//  MakeReservationView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/03.
//

import SwiftUI
import ComposableArchitecture

struct MakeReservationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) var scenePhase
    let store: Store<MakeReservationState,MakeReservationAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    AppHeaderView(title: "予約画面")
                    ZStack {
                        ScrollView{
                            VStack(alignment: .leading) {
                                Group {
                                    MenuSelectView(viewStore: viewStore)
                                        .padding(.top)
                                    PlaceSelectView(viewStore: viewStore)
                                        .onTapGesture {
                                            viewStore.send(.ticketAction(.getTicket))
                                        }
                                }
                                .padding(.leading)
                                if viewStore.showReservationDate {
                                    CalendarSelectView(viewStore: viewStore)
                                        .padding([.horizontal, .top])
                                }
                                if viewStore.showCalendar {
                                    CalendarView(viewStore: viewStore)
                                        .frame(width: bounds.width)
                                }
                                if viewStore.showTrainerSelector {
                                    TrainerSelectView(viewStore: viewStore)
                                        .padding([.horizontal, .top])
                                    if viewStore.showTrainer {
                                        TrainersView(viewStore: viewStore)
                                            .padding(.horizontal)
                                    }
                                }
                                if viewStore.showReservationTime {
                                    TimeSelectView(store: self.store.scope(state: \.timescheduleState, action: MakeReservationAction.timescheduleAction))
                                        .padding([.horizontal, .top])
                                    
                                }
                                if viewStore.timescheduleState.showTimeSchedule {
                                    TimescheduleView(viewStore: viewStore)
                                        .frame(width: bounds.width)
                                }
                                if viewStore.timescheduleState.showAddButton {
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
                        MakeReservationCheckButtonView(viewStore: viewStore)
                    }
                    .sheet(isPresented: viewStore.binding(\.$isSheet)) {
                        MakeReservationListView(store: self.store)
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
}

struct MakeReservationView_Previews: PreviewProvider {
    static var previews: some View {
        MakeReservationView(store: Store(initialState: MakeReservationState(),
                                             reducer: makeReservationReducer,
                                         environment: .live))
    }
}
