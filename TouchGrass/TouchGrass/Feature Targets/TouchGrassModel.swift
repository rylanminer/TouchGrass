//
//  TouchGrassModel.swift
//  APP NAME: TouchGrass
//  NAMES AND EMAILS: Rylan Miner (ryminer@iu.edu) & Maya Iyer (iyermaya@iu.edu)
//  SUBMISSION DATE: 05.05.25 @ 5PM
//
//  Created by Rylan Miner on 4/21/25.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI
import CoreLocation


class TouchGrassModel: NSObject, ObservableObject, CLLocationManagerDelegate {
   
    
    //Variables
    @Published var score: Int = 0
    @Published var runs: [Run] = []
    @Published var gridShowing: Bool = false
    @Published var gridSize: Int = 3
    @Published var timeRemaining: Float = 5.2
    @Published var timerRunning: Bool = false
    @Published var city: String = ""
    var effectAudioPlayer: AVAudioPlayer?
    var musicAudioPlayer: AVAudioPlayer?
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let keyToSaveRuns: String = "savedRuns_key"
        //myGrid stores the whole grid, allowing dynamic updates to indiviudal circles within the grid.
    var myGrid: [[GridCircle]] = []
    var currentCheckpoint: GridCircle?
    var checkTimer: Timer?
    
    
    
    class GridCircle {
        
        let entity: ModelEntity
        let row: Int
        let col: Int
        
        init(entity: ModelEntity, row: Int, col: Int) {
            self.entity = entity
            self.row = row
            self.col = col
        }
        
        func getRow() -> Int {
            return self.row
        }
        
        func getCol() -> Int {
            return self.col
        }
        
        func getEntity() -> ModelEntity {
            return self.entity
        }
    }

    
    //INIT
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.loadPastRuns()
    }
    
    
    func getCityFromLocation(latitude: Double, longitude: Double) {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let placemark = placemarks?.first else { return }
                if let city = placemark.locality {
                    self?.city = city  // Update the city name
                }
            }
        }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            getCityFromLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    
    
    
    //Function to randomly choose a the next green checkpoint on the grid
        //Constraints: cannot be the same checkpoint, cannot be a neighbor of the previous checkpoint
    func chooseNextCheckpoint(currentCheckpoint: GridCircle) -> GridCircle {
        
        var canidates: [GridCircle] = []
        
        //The next checkpoint cannot be the same or a neighbor of these variables
        let row = currentCheckpoint.getRow()
        let col = currentCheckpoint.getCol()
        
        //if checks for 3x3 grid first, as this grid will be allowed to choose neighbors of itself
        if self.gridSize == 3 {
            for rowIndex in myGrid.indices {
                for colIndex in myGrid[rowIndex].indices {
                    if (rowIndex == row) && (colIndex == col) {
                        //skips the current GridCircle since it is already the checkpoint
                        continue
                    }
                    canidates.append(myGrid[rowIndex][colIndex])
                }
            }
        } else {
            //looping through each row and index in the multidimensional array to identity circles on the grids that are not equal or neighbors to current checkpoint
            for rowIndex in myGrid.indices {
                for colIndex in myGrid[rowIndex].indices {
                    if (rowIndex == row) && (colIndex == col) {
                        //skips the current GridCircle since it is already the checkpoint
                        continue
                    }
                    if abs(row - rowIndex) <= 1 && abs(col - colIndex) <= 1 {
                        //skip neighbors
                        continue
                    }
                    canidates.append(myGrid[rowIndex][colIndex])
                }
            }
        }
        
       
        
        //returning a random GridCircle from the canidates array
        return canidates.randomElement()!
    }
    
    func increaseScore() {
        if timerRunning {
            score += 1
            timeRemaining = 5.2
        }
    }
    
    func setGridSize(newGridSize: Int) {
        gridSize = newGridSize
    }
    
    func resetTimer() {
        timeRemaining = 5.2
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: Date())
    }
    
    func resetGame() {
        self.score = 0
        self.timerRunning = false
    }
    
    
    //Persistent storage stuff
    func addRun(pastRun: Run) {
        runs.insert(pastRun, at: 0)
        saveRuns()
    }
    
    func saveRuns() {
        if let encodedRuns = try? JSONEncoder().encode(runs) {
            UserDefaults.standard.set(encodedRuns, forKey: keyToSaveRuns)
        }
    }
    
    func loadPastRuns(){
        if let savedData = UserDefaults.standard.data(forKey: keyToSaveRuns) {
            do {
                runs = try JSONDecoder().decode([Run].self, from: savedData)
            } catch {
                print("Failed to load runs: \(error)")
            }
        }
    }
    
    func playSound(nameOfSound: String) {
        if let soundURL = Bundle.main.url(forResource: nameOfSound, withExtension: "mp3") {
            do {
                //if statement checks if we should play sounds with the effect player or audio player, allowing audio to overlap
                if(nameOfSound == "gucci")
                {
                    musicAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    musicAudioPlayer?.play()
                } else {
                    effectAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    effectAudioPlayer?.play()
                }
                
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }
    



}

struct Run: Identifiable, Codable {
    var id = UUID()
    let points: Int
    let location: String
    let date: String
}



