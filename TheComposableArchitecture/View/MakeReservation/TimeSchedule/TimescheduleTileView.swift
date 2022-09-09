//
//  TimescheduleTileView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/10.
//

import SwiftUI

struct TimescheduleTileView: View {
    var time: TimescheduleEntity
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color("app_color"), lineWidth: 1)
            VStack {
                Text("\(time.time)")
                    .padding(.top)
                Spacer()
                Text("\(convert_state(state: time.state))")
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            .foregroundColor(Color.primary)
        }
        .frame(width: bounds.width * 0.13, height: bounds.height * 0.1)
        .background(time.isTap ? Color("app_color") : Color.clear)
    }
    
    private func convert_state(state: Int) -> String {
        switch state {
        case 0:
            return "×"
        case 1:
            return "○"
        case 2:
            return "板垣"
        case 3:
            return "二の宮"
        default:
            return "×"
        }
    }
}

struct TimescheduleTileView_Previews: PreviewProvider {
    static var previews: some View {
        TimescheduleTileView(time: TimescheduleEntity(time: "10:00", state: 0))
    }
}
