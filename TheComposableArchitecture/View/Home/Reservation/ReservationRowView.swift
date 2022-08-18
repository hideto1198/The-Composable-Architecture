//
//  ReservationRowView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/07/26.
//

import SwiftUI

struct ReservationRowView: View {
    var reservation: ReservationEntity
    var body: some View{
        ZStack{
            Color("background")
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.8), radius: 3, x:2, y: 4)
            RoundedRectangle(cornerRadius: 15)
                .stroke(self.reservation.isTap ? Color("app_color") : Color.gray, lineWidth:  self.reservation.isTap ? 1.5 : 0.5)
            VStack(alignment:.leading){
                HStack{
                    Text("メニュー　　: 　　　 ")
                    Text(self.reservation.menu)
                }
                Spacer().frame(height: bounds.height*0.010)
                HStack{
                    Text("予約日時　　: 　　　 ")
                    Text(self.reservation.date)
                }
                Spacer().frame(height: bounds.height*0.010)
                HStack{
                    Text("トレーナー　: 　　　 ")
                    Text(self.reservation.trainer_name)
                }
                Spacer().frame(height: bounds.height*0.010)
                HStack{
                    Text("場所　　　　: 　　　 ")
                    Text(self.reservation.place == "" ? "板垣店":self.reservation.place)
                }
            }
            .font(.custom("ヒラギノ角ゴシック W3", size: 11))
            .padding(.vertical,9)
        }
        .frame(height: bounds.height * 0.1)
        .padding([.horizontal, .top])
    }
}

struct ReservationRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationRowView(
            reservation: ReservationEntity(
                date: "2022年7月7日",
                place: "二の宮店",
                menu: "パーソナルトレーニング",
                trainer_name: "テスト　トレーナー",
                isTap: false
            )
        )
    }
}
