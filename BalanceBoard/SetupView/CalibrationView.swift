//
//  CalibrationView.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 23/05/22.
//

import SwiftUI
import NavigationStack

struct CalibrationView: View {
    @EnvironmentObject private var nav: NavigationStack
    @ObservedObject var bleManager = BLEManager.instance
    @StateObject private var calibrationManager = CalibrationManager()
    var body: some View {
        getCalibrationPage()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("Branco"))
            .onAppear {
                bleManager.delegates["calibrationManager"] = calibrationManager
            }
    }
    
    @ViewBuilder func getCalibrationPage() -> some View {
        switch calibrationManager.calibrationState {
        case .waiting:
            VStack(spacing: 32) {
                Text("Find your mojo!")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(.black)
                Text("Place the balance board on the floor to start the calibration")
                    .font(.custom("Helvetica", size: 32))
                    .fontWeight(.light)
                    .frame(maxWidth: 530)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Image("waitingBoard")
                    .padding(.top,120)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            calibrationManager.calibrationState = .starting
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                            .background(
                                Circle()
                                    .stroke(.black)
                                    .frame(width: 72, height: 72)
                            )
                            .padding(.vertical,12)
                    }
                    .padding(.trailing,72)
                }
                .padding()
            }
            .padding()
        case .starting:
            VStack(spacing: 12) {
                Text("Great! Time to move on!")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(.black)
                Text("Get on the board to start calibrating angles and your learning")
                    .foregroundColor(.black)
                    .font(.custom("Helvetica", size: 32))
                    .fontWeight(.light)
                    .frame(maxWidth: 530)
                    .multilineTextAlignment(.center)
                Image("startingBoard")
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.calibrationManager.calibrationState = .center
                    }
                }
            }
        case .center:
            VStack(spacing: 24) {
                Text("Let's balance!")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(.black)
                Text("Please move to the CENTER of the balance board")
                    .font(.custom("Helvetica", size: 32))
                    .foregroundColor(.black)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color("Azul"))
                        .frame(maxWidth: 560, maxHeight: 560)
                    Circle()
                        .fill(Color("Laranja"))
                        .frame(maxWidth: 400, maxHeight: 400)
                        .offset(x: calibrationManager.currentInclination.dx * 80, y: calibrationManager.currentInclination.dy * 80)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.calibrationManager.calibrationState = .left
                    }
                }
            }
        case .left:
            HStack(alignment: .center,spacing: 24) {
                VStack(alignment: .trailing) {
                    Text("Move to the left!")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    Text("Please move to the left of the balance board")
                        .font(.custom("Helvetica", size: 32))
                        .fontWeight(.light)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.black)
                        .frame(maxWidth: 305)
                }
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color("Azul"))
                        .frame(maxWidth: 560, maxHeight: 560)
                    Circle()
                        .fill(Color("Laranja"))
                        .frame(maxWidth: 400, maxHeight: 400)
                        .offset(x: calibrationManager.currentInclination.dx * 80, y: calibrationManager.currentInclination.dy * 80)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.calibrationManager.calibrationState = .right
                    }
                }
            }
        case .right:
            HStack(alignment: .center,spacing: 24) {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color("Azul"))
                        .frame(maxWidth: 560, maxHeight: 560)
                    Circle()
                        .fill(Color("Laranja"))
                        .frame(maxWidth: 400, maxHeight: 400)
                        .offset(x: calibrationManager.currentInclination.dx * 80, y: calibrationManager.currentInclination.dy * 80)
                }
                VStack(alignment: .leading) {
                    Text("Move to the right!")
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    Text("Please move to the right of the balance board")
                        .font(.custom("Helvetica", size: 32))
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 305)
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.calibrationManager.calibrationState = .down
                    }
                }
            }
        case .down:
            VStack(spacing: 24) {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color("Azul"))
                        .frame(maxWidth: 560, maxHeight: 560)
                    Circle()
                        .fill(Color("Laranja"))
                        .frame(maxWidth: 400, maxHeight: 400)
                        .offset(x: calibrationManager.currentInclination.dx * 80, y: calibrationManager.currentInclination.dy * 80)
                }
                Text("Move to the back!")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(.black)
                Text("Please move to the top of the balance board")
                    .font(.custom("Helvetica", size: 32))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.calibrationManager.calibrationState = .up
                    }
                }
            }
        case .up:
            VStack(spacing: 24) {
                Text("Move to the front!")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(.black)
                Text("Please move to the front of the balance board")
                    .font(.custom("Helvetica", size: 32))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color("Azul"))
                        .frame(maxWidth: 560, maxHeight: 560)
                    Circle()
                        .fill(Color("Laranja"))
                        .frame(maxWidth: 400, maxHeight: 400)
                        .offset(x: calibrationManager.currentInclination.dx * 80, y: calibrationManager.currentInclination.dy * 80)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.calibrationManager.calibrationState = .finished
                    }
                }
            }
        case .finished:
            HStack {
                VStack(alignment: .leading) {
                    Image("finishedCalibration")
                    Text("All right!")
                        .font(.system(size: 96, weight: .bold, design: .default))
                        .foregroundColor(Color("Verde"))
                    Text("You have balance")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .italic()
                        .foregroundColor(Color("Laranja"))
                    Text("You can use the touchscreen and the balance board to control your actions!")
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                    Text("Let's mo-mo-move!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Button(action: {
                        nav.push(MenuView())
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                            .background(
                                Circle()
                                    .stroke(.black)
                                    .frame(width: 72, height: 72)
                            )
                    }
                    .padding(.top, 64)
                }
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color("Azul"))
                        .frame(maxWidth: 810, maxHeight: 810)
                    Circle()
                        .fill(Color("Laranja"))
                        .padding(60)
                        .offset(x: calibrationManager.currentInclination.dx * 60, y: calibrationManager.currentInclination.dy * 60)
                }
            }
            .padding(32)
        }
        
    }
}

struct CalibrationView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
