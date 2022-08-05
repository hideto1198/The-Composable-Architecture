//
//  CalendarTileView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/05.
//

import SwiftUI

struct CalendarTileView: View {
    var date: String
    var state: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1)
                .stroke(Color("app_color"), lineWidth: 1)
            VStack(spacing: 7) {
                Text("\(date)")
                Text("\(state)")
                    .frame(width: bounds.width * 0.04, height: bounds.height * 0.04)
            }
        }
        .frame(width: bounds.width * 0.13, height: bounds.height * 0.09)
    }
}

struct CalendarTileView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTileView(date: "1", state: "○")
    }
}
