//
//  TrainerMakeReservation.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/07.
//

import Foundation
import ComposableArchitecture

struct TrainerMakeReservationState: Equatable {
    @BindableState var isSheet: Bool = false
    @BindableState var trainerTabSelector: Int = 0
    var calendarState: CalendarState = CalendarState()
    var trainerState: TrainerState = TrainerState()
    var trainerTimescheduleState: TrainerTimescheduleState = TrainerTimescheduleState()
    var ticketState: TicketState = TicketState()
    var inputReasonState: InputReasonState = InputReasonState()
    var reservations: [MakeReservationEntity] = []
    @BindableState var menuSelector: Int = 0
    @BindableState var placeSelector: Int = 0
    var trainerSelector: Int = 0
    var trainer: String = "選択してください"
    var showTrainerSelector: Bool = false
    var showTrainer: Bool = false
    var showCalendar: Bool = false
    var showReservationDate: Bool = false
    var showReservationTime: Bool = false
    var isLoading: Bool = false
    var alert: AlertState<TrainerMakeReservationAction>?
    
    fileprivate mutating func resetState() {
        self.trainer = "選択してください"
        self.showTrainerSelector = false
        self.showTrainer = false
        self.showCalendar = false
        self.showReservationDate = false
        self.showReservationTime = false
        
    }
}

enum TrainerMakeReservationAction: BindableAction, Equatable {
    case binding(BindingAction<TrainerMakeReservationState>)
    case calendarAction(CalendarAction)
    case trainerAction(TrainerAction)
    case trainerTimescheduleAction(TrainerTimescheduleAction)
    case ticketAction(TicketAction)
    case inputReasonAction(InputReasonAction)
    case onSelectPlace
    case onTapTrainer
    case onTapDate
    case onTapAddButton
    case onTapCheckButton
    case onDelete(IndexSet)
    case alertDismissed
    case onConfirmAlertDismissed
    case onTapConfirm
    case setTrainerReservationResponse(Result<Bool, SetTrainerReservationClient.Failure>)
}

struct TrainerMakeReservationEnvironment {
    var trainerClient: TrainerClient
    var timescheduleClient: TimescheduleClient
    var ticketClient: TicketClient
    var setTrainerReservationClient: SetTrainerReservationClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        trainerClient: TrainerClient.live,
        timescheduleClient: TimescheduleClient.live,
        ticketClient: TicketClient.live,
        setTrainerReservationClient: SetTrainerReservationClient.live,
        mainQueue: .main
    )
}

let trainerMakeReservationReducer: Reducer = Reducer<TrainerMakeReservationState, TrainerMakeReservationAction, TrainerMakeReservationEnvironment>.combine(
    calendarReducer.pullback(state: \TrainerMakeReservationState.calendarState,
                             action: /TrainerMakeReservationAction.calendarAction,
                             environment: { _ in CalendarEnvironment() }),
    trainerReducer.pullback(state: \TrainerMakeReservationState.trainerState,
                            action: /TrainerMakeReservationAction.trainerAction,
                            environment: { .init(trainerClient: $0.trainerClient, mainQueue: $0.mainQueue) }),
    trainerTimescheduleReducer.pullback(state: \TrainerMakeReservationState.trainerTimescheduleState,
                                 action: /TrainerMakeReservationAction.trainerTimescheduleAction,
                                 environment: { .init(timescheduleClient: $0.timescheduleClient, mainQueue: $0.mainQueue) }),
    ticketReducer.pullback(state: \TrainerMakeReservationState.ticketState,
                           action: /TrainerMakeReservationAction.ticketAction,
                           environment: { .init(ticketClient: $0.ticketClient, mainQueue: $0.mainQueue)}),
    inputReasonReducer.pullback(state: \TrainerMakeReservationState.inputReasonState,
                                action: /TrainerMakeReservationAction.inputReasonAction,
                                environment: { _ in InputReasonEnvironment() }),
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
            state.trainerTimescheduleState.showTimeSchedule = false
            state.trainer = trainer.trainerName
            state.showTrainer = false
            state.showReservationTime = true
            state.trainerTimescheduleState.showTimeSchedule = true
            state.trainerTimescheduleState.timeFrom = nil
            state.trainerTimescheduleState.times.removeAll()
            return Effect(value: .trainerTimescheduleAction(.getTimeschedule))
            
        case .trainerAction:
            return .none
        case .trainerTimescheduleAction(.allCancel):
            state.inputReasonState.reasons.removeAll()
            return .none
            
        case .trainerTimescheduleAction:
            return .none
        
        case .ticketAction:
            return .none
        
        // MARK: - 場所を選択したときの処理
        case .onSelectPlace:
            if state.placeSelector == 0 {
                state.resetState()
                state.trainerTimescheduleState.showTimeSchedule = false
                state.trainerTimescheduleState.showAddButton = false
            } else {
                state.resetState()
                state.trainerTimescheduleState.showTimeSchedule = false
                state.trainerTimescheduleState.showAddButton = false
                state.showCalendar = true
                state.showReservationDate = true
            }
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
            for reason in state.inputReasonState.reasons {
                state.reservations.append(MakeReservationEntity(menuName: "\(reason.item)@\(reason.note)",
                                                                placeName: state.placeSelector == 1 ? "板垣店" : "二の宮店",
                                                                year: "\(state.calendarState.year)",
                                                                month: "\(state.calendarState.month)",
                                                                day: "\(state.calendarState.date!)",
                                                                trainerName: state.trainer,
                                                                timeFrom: reason.time,
                                                                timeTo: reason.time,
                                                                displayTime: reason.time))
            }
            state.resetState()
            state.trainerTimescheduleState.showAddButton = false
            state.trainerTimescheduleState.showTimeSchedule = false
            state.inputReasonState.reasons.removeAll()
            state.trainerTimescheduleState.selectedTime.removeAll()
            state.placeSelector = 0
            return .none
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
        // MARK: - 確定ボタンを押した時
        case .onTapConfirm:
            guard state.reservations.count != 0 else {
                return .none
            }
            state.isLoading = true
            return environment.setTrainerReservationClient.fetch(state.reservations)
                .receive(on: environment.mainQueue)
                .catchToEffect(TrainerMakeReservationAction.setTrainerReservationResponse)
        case let .setTrainerReservationResponse(.success(result)):
            state.isLoading = false
            state.reservations.removeAll()
            state.alert = AlertState(title: TextState("確認"), message: TextState("予約が完了しました"), dismissButton: .default(TextState("OK"), action: .send(.onConfirmAlertDismissed)))
            return .none
            
        case let .setTrainerReservationResponse(.failure(error)):
            state.isLoading = false
            debugPrint(error)
            return .none
        case .onConfirmAlertDismissed:
            state.isSheet = false
            return .none
        case .inputReasonAction(.onTapCancel):
            state.trainerTimescheduleState.showSetPlan = false
            for time in state.trainerTimescheduleState.selectedTime {
                state.trainerTimescheduleState.times[time]!.isTap = false
            }
            state.trainerTimescheduleState.selectedTime.removeAll()
            return .none
        case .inputReasonAction(.onTapDecision):
            state.trainerTimescheduleState.showSetPlan = false
            return .none
        case .inputReasonAction:
            return .none
        }
    }
)
.binding()
