//
//  ConnectionFeedbackView.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 23/05/22.
//

import SwiftUI
import NavigationStack

struct ConnectionFeedbackView: View {
    @EnvironmentObject private var nav: NavigationStack
    
    var connected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 64) {
            Image(connected ? "connectedImage" : "notConnectedImage")
            VStack(alignment: .leading, spacing: 30) {
                Text(connected ? "Connected!" : "Not connected!")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(Color(connected ? "Verde" :  "Laranja"))
                Text(connected ? "Let's try the balance board. Put the balance board on the floor!" : "Please move the board close to your Ipad")
                    .font(.custom("Helvetica", size: 32))
                    .fontWeight(.light)
                    .lineSpacing(12)
                    .frame(maxWidth: 420)
                    .foregroundColor(.black)
                Button(action: {
                    if connected {
                        nav.push(CalibrationView())
                    } else {
                        nav.pop()
                    }
                }) {
                    if connected {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                            .background(
                                Circle()
                                    .stroke(.black)
                                    .frame(width: 72, height: 72)
                            )
                            .padding(.vertical,12)
                    } else {
                        Text("try again")
                            .font(.custom("Helvetica", size: 32))
                            .fontWeight(.light)
                            .foregroundColor(.black)
                            .padding(.vertical,12)
                            .padding(.horizontal,32)
                            .background(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.black, lineWidth: 1)
                            )
                    }
                }
                .padding(.vertical)
            }
        }
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("Branco"))
    }
}

struct ConnectionFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionFeedbackView(connected: false)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
