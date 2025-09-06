//
//  ARGameView.swift
//  APP NAME: TouchGrass
//  NAMES AND EMAILS: Rylan Miner (ryminer@iu.edu) & Maya Iyer (iyermaya@iu.edu)
//  SUBMISSION DATE: 05.05.25 @ 5PM
//
//  Created by Rylan Miner on 4/17/25.
//

import SwiftUI

struct ARGameView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var arView: CustomARViewModel? = nil
    @State private var helpMenuShowing: Bool = false
    @State private var pendingGame: Bool = true
    @ObservedObject var model: TouchGrassModel
    @State private var runAlreadySaved: Bool = false
    @State private var gameOver: Bool = false
    @State private var finalScore: Int = 0



    var body: some View {
        let buttonHeights: CGFloat = 65.0

        ZStack {
            CustomARViewModelRepresentable(arView: $arView, model: model)
                .ignoresSafeArea(edges: .top)
                .onAppear {
                    if !pendingGame {
                        //prevents multiple grids from loading into view and causing lag
                        arView?.loadGrid()
                    }
                }
                .onDisappear {
                    //prevents multiple grids from loading into view and causing lag
                    arView?.clearGrid()
                }

            VStack {
                HStack(spacing: 25) {
                    Text("Score: \(model.score)")
                    Text("\(Int(model.timeRemaining))s remaining")
                        .onReceive(model.timer) { _ in
                            if model.timeRemaining > 0 && model.timerRunning {
                                model.timeRemaining -= 0.1
                            } else if model.timerRunning {
                                
                                arView?.clearGrid()
                                model.musicAudioPlayer?.stop()

                                if !runAlreadySaved {
                                    let newRun = Run(points: model.score, location: model.city, date: model.formattedDate())
                                    model.addRun(pastRun: newRun)
                                    runAlreadySaved = true
                                }
                                
                                finalScore = model.score
                                model.resetGame()
                                pendingGame = true
                                gameOver = true
                            }
                        }
                        .alert(isPresented: $gameOver) {
                            Alert(
                                title: Text("Game Over!"),
                                message: Text("You scored \(finalScore) points. Nice job!"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: buttonHeights)
                .background(.white)
                .font(.system(size: 26))
                .foregroundColor(.black)
                .cornerRadius(50)
                .padding(.top, 60)
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(0.8)
                


            if pendingGame {                
                HStack(spacing: 20) {
                    Button(action: {
                        model.playSound(nameOfSound: "gucci")
                        model.resetTimer()
                        model.timerRunning = true
                        arView?.loadGrid()
                        runAlreadySaved = false
                        pendingGame = false
                        helpMenuShowing = false
                    }, label: {
                        Text("START GAME")
                            .frame(width: UIScreen.main.bounds.width * 0.7, height: buttonHeights)
                            .background(.white)
                            .font(.system(size: 26))
                            .foregroundColor(.black)
                            .underline()
                            .cornerRadius(50)
                            .bold()
                    })
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        withAnimation {
                            helpMenuShowing.toggle()
                            model.playSound(nameOfSound: "dramatic")
                        }
                    }, label: {
                        Image(systemName: helpMenuShowing ? "xmark.circle.fill" : "questionmark.circle.fill")
                            .resizable()
                            .frame(width: buttonHeights-20, height: buttonHeights-20)
                            .foregroundColor(helpMenuShowing ? .red : .white)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.bottom, 20)
                .opacity(helpMenuShowing ? 1.0 : 0.8)
                .frame(maxHeight: .infinity, alignment: .bottom)
              }
            }
                

            if helpMenuShowing {
                VStack {
                    Text("How to play Touch Grass:")
                        .bold()
                        .padding(.bottom, 10)
                        .font(.system(size: 20))
                    Text("1. Set your preferred grid layout on the settings page (standard is 3x3)\n2. Prop up your camera at a distance so that you can see the grid layout in full\n3. Once Start is pressed, a grid position will turn green. You must run to this place before the time runs out\n4. Each successful round will be followed by a new position turning green and less time on the clock. Your goal is to make it through as many rounds as possible\n5. The game will end once a round is failed\n\nThank you for playing Touch Grass and have fun!")
                }
                .padding([.leading, .trailing], 30)
                .padding([.top, .bottom], 50)
                .foregroundStyle(.black)
                .background(.white)
                .frame(maxWidth: 300)
                .cornerRadius(50)
                .transition(.opacity)
                .animation(.easeInOut(duration: 5.0), value: helpMenuShowing)
            }
        }
    }
}
