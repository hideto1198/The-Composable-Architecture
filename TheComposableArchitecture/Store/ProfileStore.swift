//
//  ProfileStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import Foundation
import ComposableArchitecture

struct ProfileEntity: Equatable {
    var userName: String = ""
    var userKanaName: String = ""
    var birthday: String = ""
    var sex: String = ""
}
struct ProfileState: Equatable {
    @BindableState var isLaunch: Bool = false
    @BindableState var firstName1: String = "\(UserDefaults.standard.string(forKey: "userName")?.components(separatedBy: "　")[0] ?? "　")" // 姓
    @BindableState var firstName2: String = "\(UserDefaults.standard.string(forKey: "userKanaName")?.components(separatedBy: "　")[0] ?? "　")"  // セイ
    @BindableState var lastName1: String = "\(UserDefaults.standard.string(forKey: "userName")?.components(separatedBy: "　")[1] ?? "　")"   // 名
    @BindableState var lastName2: String = "\(UserDefaults.standard.string(forKey: "userKanaName")?.components(separatedBy: "　")[1] ?? "　")"   // メイ
    @BindableState var sexSelector: Int = 0
    @BindableState var date: Date = Date()
    var profile: ProfileEntity = ProfileEntity()
    var alert: AlertState<ProfileAction>?
    
    init() {
        self.sexSelector = UserDefaults.standard.string(forKey: "sex") == "男" ? 1 : UserDefaults.standard.string(forKey: "sex") == "女" ? 2 : 0
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        self.date = dateFormatter.date(from: UserDefaults.standard.string(forKey: "birthday")!)!
    }
}

enum ProfileAction: BindableAction, Equatable {
    case binding(BindingAction<ProfileState>)
    case onAppear
    case onSave
    case saveResponse(Result<Bool, ProfileClient.Failure>)
    case alertDismissed
    case onSignOut
    case confirmSignout
    case signOutResponse(Result<Bool, SignOutClient.Failure>)
    case navigateHome
}

struct ProfileEnvironment {
    var profileClient: ProfileClient
    var signOutClient: SignOutClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    static let live = Self(
        profileClient: ProfileClient.live,
        signOutClient: SignOutClient.live,
        mainQueue: .main
    )
}

let profileReducer: Reducer = Reducer<ProfileState, ProfileAction, ProfileEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
    case .onAppear:
        state.profile = ProfileEntity(
            userName: UserDefaults.standard.string(forKey: "userName") ?? "",
            userKanaName: UserDefaults.standard.string(forKey: "userKanaName") ?? "",
            birthday: UserDefaults.standard.string(forKey: "birthday") ?? "",
            sex: UserDefaults.standard.string(forKey: "sex") ?? ""
        )
        return .none
    case .onSave:
        var dateFormatter: DateFormatter {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
            return dateFormatter
        }
        let request: [String: String] = [
            "firstName1": state.firstName1,
            "firstName2": state.firstName2,
            "lastName1": state.lastName1,
            "lastName2": state.lastName2,
            "sex": state.sexSelector == 1 ? "男" : state.sexSelector == 2 ? "女" : "-",
            "birthday": dateFormatter.string(from: state.date)
        ]
        return environment.profileClient.fetch(request)
            .receive(on: environment.mainQueue)
            .catchToEffect(ProfileAction.saveResponse)
    case .saveResponse(.success):
        state.alert = AlertState(title: TextState("確認"),
                                 message: TextState("保存しました"))
        return .none
    case .saveResponse(.failure):
        return .none
        
    case .alertDismissed:
        state.alert = nil
        return .none
    case .confirmSignout:
        state.alert = AlertState(title: TextState("確認"),
                                 message: TextState("サインアウトしますか？"),
                                 primaryButton: .cancel(TextState("いいえ")),
                                 secondaryButton: .destructive(TextState("はい"), action: .send(.onSignOut)))
        return .none
    case .onSignOut:
        return environment.signOutClient.fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(ProfileAction.signOutResponse)
    case .signOutResponse(.success):
        state.alert = AlertState(title: TextState("確認"),
                                 message: TextState("サインアウトしました。"),
                                 dismissButton: .default(TextState("OK"),
                                                         action: .send(.navigateHome)))
        return .none
    case .signOutResponse(.failure):
        return .none
    case .navigateHome:
        state.alert = nil
        state.isLaunch = true
        return .none
    }
}
.binding()
