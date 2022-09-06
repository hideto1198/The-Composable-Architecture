//
//  MakeReservationStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/03.
//

import Foundation
import ComposableArchitecture


struct MakeReservationEntity: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var menuName: String
    var placeName: String
    var year: String
    var month: String
    var day: String
    var trainerName: String = ""
    var timeFrom: String
    var timeTo: String
    var displayTime: String
}

struct MakeReservationState: Equatable {
    @BindableState var isSheet: Bool = false
    @BindableState var trainerTabSelector: Int = 0
    var calendarState: CalendarState = CalendarState()
    var trainerState: TrainerState = TrainerState()
    var timescheduleState: TimescheduleState = TimescheduleState()
    var ticketState: TicketState = TicketState()
    var reservations: [MakeReservationEntity] = []
    var menuSelector: Int = 0
    var placeSelector: Int = 0
    var trainerSelector: Int = 0
    var trainer: String = "選択してください"
    var showTrainerSelector: Bool = false
    var showTrainer: Bool = false
    var showCalendar: Bool = false
    var showReservationDate: Bool = false
    var showReservationTime: Bool = false
    var isLoading: Bool = false
    var alert: AlertState<MakeReservationAction>?
    
    fileprivate mutating func resetState() {
        self.trainer = "選択してください"
        self.showTrainerSelector = false
        self.showTrainer = false
        self.showCalendar = false
        self.showReservationDate = false
        self.showReservationTime = false
        
    }
}

enum MakeReservationAction: BindableAction, Equatable {
    case binding(BindingAction<MakeReservationState>)
    case calendarAction(CalendarAction)
    case trainerAction(TrainerAction)
    case timescheduleAction(TimescheduleAction)
    case ticketAction(TicketAction)
    case onSelectMenu(Int)
    case onSelectPlace(Int)
    case onTapTrainer
    case onTapDate
    case onTapAddButton
    case onTapCheckButton
    case onDelete(IndexSet)
    case alertDismissed
    case onConfirmAlertDismissed
    case onTapConfirm
    case setReservationResponse(Result<Bool, SetReservationClient.Failure>)
}

struct MakeReservationEnvironment {
    var trainerClient: TrainerClient
    var timescheduleClient: TimescheduleClient
    var ticketClient: TicketClient
    var setReservationClient: SetReservationClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        trainerClient: TrainerClient.live,
        timescheduleClient: TimescheduleClient.live,
        ticketClient: TicketClient.live,
        setReservationClient: SetReservationClient.live,
        mainQueue: .main
    )
}

let makeReservationReducer: Reducer = Reducer<MakeReservationState, MakeReservationAction, MakeReservationEnvironment>.combine(
    calendarReducer.pullback(state: \MakeReservationState.calendarState,
                             action: /MakeReservationAction.calendarAction,
                             environment: { _ in CalendarEnvironment() }),
    trainerReducer.pullback(state: \MakeReservationState.trainerState,
                            action: /MakeReservationAction.trainerAction,
                            environment: { .init(trainerClient: $0.trainerClient, mainQueue: $0.mainQueue) }),
    timescheduleReducer.pullback(state: \MakeReservationState.timescheduleState,
                                 action: /MakeReservationAction.timescheduleAction,
                                 environment: { .init(timescheduleClient: $0.timescheduleClient, mainQueue: $0.mainQueue) }),
    ticketReducer.pullback(state: \MakeReservationState.ticketState,
                           action: /MakeReservationAction.ticketAction,
                           environment: { .init(ticketClient: $0.ticketClient, mainQueue: $0.mainQueue)}),
    Reducer { state, action, environment in
        switch action {
        case .binding:
            return .none
        // MARK: - カレンダーの日付を押したときの処理
        case let .calendarAction(.onTapTile(date)):
            state.showTrainer = false
            if date.state == "○" {
                state.showTrainerSelector = true
                state.showCalendar = false
                state.showReservationDate = true
                state.showTrainer = true
                state.calendarState.date = date.date
                let request = [
                    "year": "\(state.calendarState.year)",
                    "month": "\(state.calendarState.month)",
                    "day": state.calendarState.date!,
                    "place": state.placeSelector == 1 ? "板垣店" : "二の宮店"
                ]
                return Effect(value: .trainerAction(.getTrainer(request)))
            } else {
                state.calendarState.date = nil
                state.showTrainer = false
                return .none
            }
            
        case .calendarAction:
            return .none
        // MARK: - トレーナーを選択したときの処理
        case let .trainerAction(.onTapTrainer(trainer)):
            state.timescheduleState.showTimeSchedule = false
            state.trainer = trainer.trainerName
            state.showTrainer = false
            state.showReservationTime = true
            state.timescheduleState.showTimeSchedule = true
            state.timescheduleState.timeFrom = nil
            state.timescheduleState.times.removeAll()
            return Effect(value: .timescheduleAction(.getTimeschedule))
            
        case .trainerAction:
            return .none
                
        case .timescheduleAction:
            return .none
        
        case .ticketAction:
            return .none
        case let .onSelectMenu(index):
            state.menuSelector = index
            return .none
        
        // MARK: - 場所を選択したときの処理
        case let .onSelectPlace(index):
            if index == 0 {
                state.resetState()
                state.timescheduleState.showTimeSchedule = false
                state.timescheduleState.showAddButton = false
            } else {
                state.resetState()
                state.timescheduleState.showTimeSchedule = false
                state.timescheduleState.showAddButton = false
                state.showCalendar = true
                state.showReservationDate = true
            }
            state.placeSelector = index
            return .none
            
        case .onTapTrainer:
            state.showTrainer.toggle()
            return .none
            
        case .onTapDate:
            state.resetState()
            state.showCalendar = true
            state.showReservationDate = true
            return .none

        // MARK: - 追加ボタンを押したときの処理
        case .onTapAddButton:
            if state.ticketState.ticket.counts == state.reservations.count {
                state.alert = AlertState(title: TextState("エラー"), message: TextState("これ以上追加できません。"))
                return .none
            } else {
                state.reservations.append(MakeReservationEntity(menuName: state.menuSelector == 0 ? "パーソナルトレーニング" : "",
                                                                placeName: state.placeSelector == 1 ? "板垣店" : "二の宮店",
                                                                year: "\(state.calendarState.year)",
                                                                month: "\(state.calendarState.month)",
                                                                day: "\(state.calendarState.date!)",
                                                                trainerName: state.trainer,
                                                                timeFrom: state.timescheduleState.timeFrom!,
                                                                timeTo: state.timescheduleState.timeTo!,
                                                                displayTime: state.timescheduleState.displayTime!))
                state.resetState()
                state.timescheduleState.showAddButton = false
                state.placeSelector = 0
                return .none
            }
        // MARK: - 予約リストをチェックする
        case .onTapCheckButton:
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日 H:m"
            let sortedReservations: [MakeReservationEntity] = state.reservations.sorted(by: { (ldate, rdate) -> Bool in
                let leftDate: Date = dateFormatter.date(from: "\(ldate.year)年\(ldate.month)月\(ldate.day)日 \(ldate.timeFrom)")!
                let rightDate: Date = dateFormatter.date(from: "\(rdate.year)年\(rdate.month)月\(rdate.day)日 \(rdate.timeFrom)")!
                return leftDate < rightDate
            })
            state.reservations = sortedReservations
            state.isSheet = true
            return .none
        case let .onDelete(offsets):
            state.reservations.remove(atOffsets: offsets)
            return .none
        case .alertDismissed:
            state.alert = nil
            return .none
        case .onTapConfirm:
            guard state.reservations.count != 0 else {
                return .none
            }
            state.isLoading = true
            return environment.setReservationClient.fetch(state.reservations)
                .receive(on: environment.mainQueue)
                .catchToEffect(MakeReservationAction.setReservationResponse)
        case let .setReservationResponse(.success(result)):
            state.isLoading = false
            state.reservations.removeAll()
            state.alert = AlertState(title: TextState("確認"), message: TextState("予約が完了しました"), dismissButton: .default(TextState("OK"), action: .send(.onConfirmAlertDismissed)))
            return .none
            
        case .setReservationResponse(.failure):
            state.isLoading = false
            return .none
        case .onConfirmAlertDismissed:
            state.isSheet = false
            return .none
        }
    }
)
.binding()
