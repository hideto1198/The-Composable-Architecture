//
//  LaunchStore.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/02.
//

import Foundation
import ComposableArchitecture

struct line: Equatable {
    var x: CGFloat
    var y: CGFloat
}
struct LaunchState: Equatable {
    var isLaunch: Bool = false
    var lines: [line] = [
        line(x: bounds.width * 0.1410, y: 0),
        line(x: bounds.width * 0.3332, y: bounds.width * 0.2774),
        line(x: bounds.width * 0.2497, y: bounds.width * 0.1338)
    ]
    var opacity: Double = 2.0
    var counter: Double = 0.0
}

enum LaunchAction: Equatable {
    case timer(LifecycleAction<TimerAction>)
    case onNavigate
    case doAnimation
}

struct LaunchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let launchReducer: Reducer<LaunchState, LaunchAction, LaunchEnvironment> = .combine(
    timerReducer.pullback(
        state: \.self,
        action: /LaunchAction.timer,
        environment: { TimerEnvironment(mainQueue: $0.mainQueue) }
    ),
    Reducer { state, action, environemnt in
        switch action {
        case .timer:
            return .none
        case .onNavigate:
            state.isLaunch = true
            return .none
        case .doAnimation:
            return .none
        }
    }
)

extension Reducer {
    public func lifecycle(
        onAppear: @escaping (Environment) -> Effect<Action, Never>,
        onDisappear: @escaping (Environment) -> Effect<Never, Never>
    ) -> Reducer<State, LifecycleAction<Action>, Environment> {
        return .init { state, lifecycleAction, environment in
            switch lifecycleAction {
            case .onAppear:
                return onAppear(environment).map(LifecycleAction.action)
            case .onDisappear:
                return onDisappear(environment).fireAndForget()
            case let .action(action):
                return self.run(&state, action, environment)
                    .map(LifecycleAction.action)
            }
        }
    }
}

public enum LifecycleAction<Action> {
  case onAppear
  case onDisappear
  case action(Action)
}

extension LifecycleAction: Equatable where Action: Equatable {}

enum TimerID {}

enum TimerAction {
    case tick
}

struct TimerEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let timerReducer: Reducer = Reducer<LaunchState, TimerAction, TimerEnvironment> { state, action, TimerEnvironment in
    switch action {
    case .tick:
        if state.counter < 2 {
            state.counter += 0.01
        }
        if state.lines[0].x < bounds.width * 0.353 {
            state.lines[0].x += 1
        } else if state.lines[1].x > bounds.width * 0.2397 || state.lines[1].y > bounds.width * 0.1138 {
            state.lines[1].x -= 0.59
            state.lines[1].y -= 1
        } else if state.lines[2].x > bounds.width * 0.1816 || state.lines[2].y < bounds.width * 0.2512 {
            state.lines[2].x -= 1
            state.lines[2].y += 1.75
        } else if state.opacity > 0 {
            state.opacity -= 0.008
        }
        return .none
    }
}
.lifecycle(onAppear: {
    Effect.timer(id: TimerID.self, every: 0.005, tolerance: 0,on: $0.mainQueue)
        .map{ _ in TimerAction.tick }
}, onDisappear: { _ in
        .cancel(id: TimerID.self)
})
