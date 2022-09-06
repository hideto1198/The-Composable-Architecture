//
//  TrainerReservationRowView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/06.
//

import SwiftUI

struct TrainerReservationRowView: View {
    let detail: GymDetailEntity
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("メニュー　 :　　 \(detail.menuName)")
                    Text("予約時間　 :　　 \(detail.times[0])~\(detail.times[1])")
                    Text("ユーザー　 :　　 \(detail.userName)")
                    Text("場所　　　 :　　 \(detail.placeName)")
                }
                .font(.custom("", size: 15))
                .foregroundColor(Color.primary)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct TrainerReservationRowView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerReservationRowView(detail: GymDetailEntity(trainerName: "テスト　トレーナー",
                                                          userName: "東　秀斗",
                                                          menuName: "パーソナルトレーニング",
                                                          placeName: "板垣店",
                                                          times: ["10:00", "11:00"]))
    }
}
