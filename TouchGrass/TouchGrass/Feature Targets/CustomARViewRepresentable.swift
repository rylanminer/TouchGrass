//
//  CustomARViewModelRepresentable.swift
//  APP NAME: TouchGrass
//  NAMES AND EMAILS: Rylan Miner (ryminer@iu.edu) & Maya Iyer (iyermaya@iu.edu)
//  SUBMISSION DATE: 05.05.25 @ 5PM
//
//  Created by Rylan Miner on 4/16/25.
//

import SwiftUI

//conforms to a UIViewRepresentable, basically allowing us to use this in a SwiftUIViews body
struct CustomARViewModelRepresentable: UIViewRepresentable {
    @Binding var arView: CustomARViewModel?
    var model: TouchGrassModel

    func makeUIView(context: Context) -> CustomARViewModel {
           let CustomARViewModel = CustomARViewModel(model: model)
           arView = CustomARViewModel
           return CustomARViewModel
       }

    func updateUIView(_ uiView: CustomARViewModel, context: Context) {}
}

