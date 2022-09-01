//
//  TrainerHomeCalendarTileView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/26.
//

import SwiftUI

struct TrainerHomeCalendarTileView: View {
    var date: DateEntity
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1)
                .stroke(date.isToday ? Color.blue : Color("app_color"), lineWidth: 1)
            VStack(spacing: 7) {
                Text("\(date.date)")
                    .background(Circle()
                        .foregroundColor(date.isToday ? Color.blue.opacity(0.6) : Color("primary_white"))
                        .frame(width: bounds.width * 0.058, height: bounds.height * 0.058))
                    .foregroundColor(.primary)
                Group {
                    if date.state == "99" {
                        ActivityIndicator()
                    } else {
                        Text("\(date.state)")
                            .frame(width: bounds.width * 0.04, height: bounds.height * 0.03)
                    }
                }
            }
        }
        .frame(width: bounds.width * 0.13, height: bounds.height * 0.08)
        .background(Color("primary_white"))
    }
}

struct TrainerHomeCalendarTileView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerHomeCalendarTileView(date: DateEntity(date: "1", state: "予", isToday: true))
    }
}
