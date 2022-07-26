//
//  LaunchDesignView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/02.
//

import SwiftUI
import ComposableArchitecture

struct LaunchDesignView: View {
    var viewStore: ViewStore<LaunchState, LaunchAction>
    
    var body: some View {
        ZStack {
            Color("app_color")
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Group {
                    Image("LOGO")
                        .resizable()
                    Path { path in
                        path.addLines([
                            CGPoint(x: viewStore.state.lines[0].x, y: bounds.width * 0.2774),
                            CGPoint(x: bounds.width * 0.353, y: bounds.width * 0.2774)
                        ])
                    }
                    .stroke(Color("app_color"), style: StrokeStyle(lineWidth: bounds.width * 0.026))
                    Path{ path in
                        path.addLines([
                            CGPoint(x: viewStore.state.lines[1].x, y: viewStore.state.lines[1].y),
                            CGPoint(x: bounds.width * 0.2397, y: bounds.width * 0.1138)
                        ])
                    }
                    .stroke(Color("app_color"), style:StrokeStyle(lineWidth: bounds.width * 0.026))
                    Path{ path in
                        path.addLines([
                            CGPoint(x: viewStore.state.lines[2].x, y: viewStore.state.lines[2].y),
                            CGPoint(x: bounds.width * 0.1816, y: bounds.width * 0.2512)
                        ])
                    }
                    .stroke(Color("app_color"), style:StrokeStyle(lineWidth: bounds.width * 0.026))
                }
                .opacity(viewStore.state.opacity)
                .frame(width: bounds.width * 0.5, height: bounds.width * 0.5)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewStore.send(.timer(.onAppear))
        }
        .onDisappear{
            viewStore.send(.timer(.onDisappear))
        }
    }
}


 struct LaunchDesignView_Previews: PreviewProvider {
     static var previews: some View {
         LaunchDesignView(viewStore: ViewStore(Store(initialState: LaunchState(),
                                        reducer: launchReducer,
                                        environment: .init(mainQueue: .main, authenticationClient: .live))))
     }
 }
 
