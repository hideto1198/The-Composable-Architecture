//
//  TrainerCalendarDetailRowView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/30.
//

import SwiftUI

struct TrainerCalendarDetailRowView: View {
    let detail: GymDetailEntity
    
    var body: some View {
        Group {
            if detail.userName != detail.trainerName && detail.userName != "トレーナー　同士" {
                VStack(alignment: .leading) {
                    Text("\(detail.trainerName)")
                        .font(.custom("", size: 13))
                        .padding(.bottom, 2)
                    HStack {
                        VStack {
                            Text("\(detail.times[0])")
                            Text("\(detail.times[1])")
                        }
                        .font(.custom("", size: 12))
                        Text("|")
                            .font(.custom("", size: 22))
                            .foregroundColor(Color("app_color"))
                        VStack(alignment: .leading) {
                            Text("\(detail.userName)　様")
                                .font(.custom("", size: 14))
                            Group {
                                Text("\(detail.menuName)")
                                Text("場所：\(detail.placeName)")
                            }
                            .foregroundColor(Color.gray)
                            .font(.custom("", size: 11))
                        }
                        Spacer()
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text("\(detail.trainerName)\(detail.userName == "トレーナー　同士" ? "　(トレーナー同士)" : "")")
                        .font(.custom("", size: 13))
                        .padding(.bottom, 2)
                    HStack {
                        VStack {
                            Text("\(detail.times[0])")
                            Text("\(detail.times[1])")
                        }
                        .font(.custom("", size: 12))
                        Text("|")
                            .font(.custom("", size: 22))
                            .foregroundColor(Color("app_color"))
                        VStack(alignment: .leading) {
                            Text("予定：\(detail.menuName)")
                            Text("内容：\(detail.placeName)")
                        }
                        .font(.custom("", size: 12))
                    }
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .opacity(detail.opacity)
    }
}

struct TrainerCalendarDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerCalendarDetailRowView(detail: GymDetailEntity(trainerName: "テスト　トレーナー",
                                                             userName: "東　秀斗",
                                                             menuName: "パーソナルトレーニング",
                                                             placeName: "二の宮店",
                                                             times: ["10:00", "11:00"]))
    }
}
