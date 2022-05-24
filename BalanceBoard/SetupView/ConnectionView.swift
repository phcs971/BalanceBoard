//
//  ConnectionView.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 23/05/22.
//

import Foundation
import SwiftUI
import NavigationStack

struct ConnectionView: View {
    @ObservedObject var bleManager: BLEManager = BLEManager.instance
    @EnvironmentObject private var nav: NavigationStack
    @State var rotation = false
    private let circleRadius: CGFloat = 400
    var body: some View {
        VStack {
            Text("Searching for nearby boards")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.black)
            Text("Please turn on and move the board close to your device")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.black)
            ZStack(alignment: .center) {
                Circle()
                    .stroke(.orange, lineWidth: 1)
                    .frame(width: circleRadius, height: circleRadius)
                Circle()
                    .fill(
                        AngularGradient(
                            colors: [.orange.opacity(0.5),.orange.opacity(0),.orange.opacity(0),.orange.opacity(0),.orange.opacity(0),.orange.opacity(0),.orange.opacity(0),.orange.opacity(0),.orange.opacity(0)],
                            center: .center,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 360)
                        )
                    )
                   .frame(width: circleRadius, height: circleRadius)
                   .rotationEffect(Angle(degrees: rotation ? -360 : 0))
                   .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
                   .onAppear {
                       rotation.toggle()
                   }
                   .opacity(bleManager.connectionState == .scanning ? 1 : 0)
            }
            .padding()
            
            
            HStack {
                Spacer().frame(width: 200)
                Spacer()
                Button(action: {
                    bleManager.start()
                }) {
                    Text("Scan for boards")
                        .font(.custom("Helvetica", size: 32))
                        .fontWeight(.light)
                        .foregroundColor(.black)
                        .padding(.vertical,28)
                        .padding(.horizontal,64)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.black, lineWidth: 1)
                        )
                }
                Spacer()
                Button {
                    nav.push(MenuView())
                } label: {
                    Text("CONTINUE\nWITHOUT\nCONNECTING")
                        .font(.custom("Helvetica", size: 16))
                        .fontWeight(.light)
                        .foregroundColor(.black)
                        .padding(.vertical,4)
                        .padding(.horizontal,32)
                }
                .background(
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(.black, lineWidth: 1)
                )
                .frame(width: 200)

            }
            .padding()
        }
        .onChange(of: bleManager.connectionState) { newValue in
            if newValue == .connected || newValue == .failed {
                nav.push(ConnectionFeedbackView(connected: newValue == .connected))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("Branco"))
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
