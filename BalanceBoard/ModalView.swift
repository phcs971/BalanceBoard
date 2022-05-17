//
//  ModalView.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 16/05/22.
//

import SwiftUI

struct ModalView: View {
    var body: some View {
        VStack {
            Text("Conecte um dispositivo")
            Button(action: {
                BLEManager.instance.start()
            }) {
                Text("Conectar")
                    .padding()
                    .background(.black)
                    .cornerRadius(5)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(.gray)
        .cornerRadius(10)
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
    }
}
