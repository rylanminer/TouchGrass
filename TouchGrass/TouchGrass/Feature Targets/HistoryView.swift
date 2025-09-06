//
//  HistoryView.swift
//  APP NAME: TouchGrass
//  NAMES AND EMAILS: Rylan Miner (ryminer@iu.edu) & Maya Iyer (iyermaya@iu.edu)
//  SUBMISSION DATE: 05.05.25 @ 5PM
//
//  Created by Rylan Miner on 4/16/25.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var model: TouchGrassModel
    @State var hasData: Bool = true

        var body: some View {
            let groupedRuns = Dictionary(grouping: model.runs) { $0.date }

            VStack {
                HStack {
                    Text("Past Runs").font(.title)
                        .padding(.leading, 30)
                        .bold(true)
                    Spacer()
                } .padding(.top, 30)
                
                if hasData {
                    List {
                        ForEach(groupedRuns.keys.sorted(by: >), id: \.self) { date in
                            if let runs = groupedRuns[date] {
                                Section(header: Text(date)) {
                                    ForEach(runs) { run in
                                        VStack(alignment: .leading) {
                                            Text("\(run.points) points")
                                            Text(run.location)
                                                .foregroundColor(.gray)
                                                .font(.body.smallCaps())
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("nothing yet")
                }
                
                
            }
            
            
        }
}

#Preview {
    ContentView()
}
