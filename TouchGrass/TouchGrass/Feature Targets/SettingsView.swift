//
//  Settings.swift
//  APP NAME: TouchGrass
//  NAMES AND EMAILS: Rylan Miner (ryminer@iu.edu) & Maya Iyer (iyermaya@iu.edu)
//  SUBMISSION DATE: 05.05.25 @ 5PM
//
//  Created by Rylan Miner on 4/16/25.
//

import SwiftUI

struct SettingsView: View {
    
    //Getting the color scheme to make dynamic changes to font color and button color
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var model: TouchGrassModel
    @State private var localGridSize: Int = 3

    
    var body: some View {
        
        
        VStack {
            Text("Customize your Experience")
                .underline()
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 26))
                .bold()
            
            VStack {
                Button(action: {
                    localGridSize = localGridSize < 5 ? localGridSize + 1 : localGridSize

                }, label: {
                    Text("+")
                    .font(.system(size: 100))
                    .foregroundColor(.green)
                        
                })
                .buttonStyle(PlainButtonStyle())
                
                Text ("\(self.localGridSize) x \(self.localGridSize)")
                    .font(.system(size: 135))
                
                Text ("grid size")
                    .font(.system(size: 25))
                
                Button(action: {
                    localGridSize = localGridSize > 3 ? localGridSize - 1 : localGridSize
                }, label: {
                    Text("—")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .bold()
                    .padding()
                })
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    model.setGridSize(newGridSize: self.localGridSize)
                }, label: {
                    Text("SUBMIT CHANGES")
                    .font(.system(size: 20))
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .background(colorScheme == .dark ? .white : .black)
                    .bold()
                    .cornerRadius(30)
                })
                .padding([.top], 40)
                .buttonStyle(PlainButtonStyle())
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
