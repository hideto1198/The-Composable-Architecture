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
    var menu_name: String
    var place_name: String
    var year: String
    var month: String
    var day: String
    var trainer_name: String = ""
    var time_from: String
    var time_to: String
    var display_time: String
}

struct MakeReservationState: Equatable {
    var reservations: [MakeReservationEntity] = []
    var menuSelector: Int = 0
    var placeSelector: Int = 0
    var trainerSelector: Int = 0
    var trainer: String = "選択してください"
    var showTrainerSelector: Bool = false
    var showTrainer: Bool = false
    var showCalendar: Bool = false
    var showReservationDate: Bool = false
    var reservation_date: String = "選択してください"
    var showTimeSchedule: Bool = false
    var reservationTime: String = "選択してください"
    var showReservationTime: Bool = false
    var showAddButton: Bool = false
    var calendarState: CalendarState = CalendarState()
    var trainerState: TrainerState = TrainerState()
    var timescheduleState: TimescheduleState = TimescheduleState()
    var ticketState: TicketState = TicketState()
    var year: String = ""
    var month: String = ""
    var day: String = ""
    var time_from: String = ""
    var time_to: String = ""
    var displayTime: String = ""
    @BindableState var isSheet: Bool = false
    var alert: AlertState<MakeReservationAction>?
    var isLoading: Bool = false
    
    fileprivate mutating func resetState(){
        self.trainer = "選択してください"
        self.showTrainerSelector = false
        self.showTrainer = false
        self.showCalendar = false
        self.showReservationDate = false
        self.reservation_date = "選択してください"
        self.showTimeSchedule = false
        self.showReservationTime = false
        self.reservationTime = "選択してください"
        self.showAddButton = false
        
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
    case onTapTime
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
                state.reservation_date = "\(state.calendarState.year)年\(state.calendarState.month)月\(date.date)日"
                state.year = "\(state.calendarState.year)"
                state.month = "\(state.calendarState.month)"
                state.day = date.date
                return Effect(value: .trainerAction(.getTrainer))
            } else {
                state.year = ""
                state.month = ""
                state.day = ""
                state.showTrainer = false
                return .none
            }
            
        case .calendarAction:
            return .none
        // MARK: - トレーナーを選択したときの処理
        case let .trainerAction(.onTapTrainer(trainer)):
            state.showTimeSchedule = false
            state.trainer = trainer.trainer_name
            state.showTrainer = false
            state.showReservationTime = true
            state.reservationTime = "選択してください"
            state.showTimeSchedule = true
            state.timescheduleState.times.removeAll()
            return Effect(value: .timescheduleAction(.getTimeschedule))
            
        case .trainerAction:
            return .none
        
        // MARK: - 時間を選択したときの処理
        case let .timescheduleAction(.onTapTime(time)):
            guard time != "22:30" else { return .none }
            let next_time: String = next_time_value(time: time)
            let display_time: String = next_time_value(time: next_time)
            if state.timescheduleState.times[time]!.state == 1 && state.timescheduleState.times[next_time]!.state == 1 {
                state.reservationTime = "\(time)〜\(display_time)"
                state.time_from = time
                state.time_to = next_time
                state.displayTime = display_time
                state.showTimeSchedule = false
                state.showAddButton = true
            } else {
                state.time_from = ""
                state.time_to = ""
                state.displayTime = ""
                state.showAddButton = false
            }
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
            } else {
                state.resetState()
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
            
        case .onTapTime:
            state.showTimeSchedule.toggle()
            return .none
        // MARK: - 追加ボタンを押したときの処理
        case .onTapAddButton:
            if state.ticketState.ticket.counts == state.reservations.count {
                state.alert = AlertState(title: TextState("エラー"), message: TextState("これ以上追加できません。"))
                return .none
            } else {
                state.reservations.append(MakeReservationEntity(menu_name: state.menuSelector == 0 ? "パーソナルトレーニング" : "",
                                                                place_name: state.placeSelector == 1 ? "板垣店" : "二の宮店",
                                                                year: state.year,
                                                                month: state.month,
                                                                day: state.day,
                                                                trainer_name: state.trainer,
                                                                time_from: state.time_from,
                                                                time_to: state.time_to,
                                                                display_time: state.displayTime))
                state.resetState()
                state.placeSelector = 0
                return .none
            }
        // MARK: - 予約リストをチェックする
        case .onTapCheckButton:
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日 H:m"
            let sorted_reservations: [MakeReservationEntity] = state.reservations.sorted(by: { (ldate, rdate) -> Bool in
                let left_date: Date = dateFormatter.date(from: "\(ldate.year)年\(ldate.month)月\(ldate.day)日 \(ldate.time_from)")!
                let right_date: Date = dateFormatter.date(from: "\(rdate.year)年\(rdate.month)月\(rdate.day)日 \(rdate.time_from)")!
                return left_date < right_date
            })
            state.reservations = sorted_reservations
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

fileprivate func next_time_value(time: String) -> String {
    let times: [String] = [
        "9:00","9:30","10:00","10:30","11:00","11:30",
        "12:00","12:30","13:00","13:30","14:00","14:30",
        "15:00","15:30","16:00","16:30","17:00","17:30",
        "18:00","18:30","19:00","19:30","20:00","20:30",
        "21:00","21:30","22:00","22:30","23:00"
    ]
    let result: Int = times.firstIndex(of: time)! + 1
    return times[result]
}
