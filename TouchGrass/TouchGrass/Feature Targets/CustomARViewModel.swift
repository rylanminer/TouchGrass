//
//  CustomARViewModel.swift
//  APP NAME: TouchGrass
//  NAMES AND EMAILS: Rylan Miner (ryminer@iu.edu) & Maya Iyer (iyermaya@iu.edu)
//  SUBMISSION DATE: 05.05.25 @ 5PM
//
//  Created by Rylan Miner on 4/16/25.
//

import ARKit
import RealityKit
import SwiftUI




class CustomARViewModel: ARView {
    var model: TouchGrassModel!
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //this is the init that is going to be used
    convenience init(model: TouchGrassModel) {
        self.init(frame: UIScreen.main.bounds)
        self.model = model
    }
    
    
    func loadGrid () {
        
        //Reset the grid to blank
        model.myGrid = []
        
        let spacing: Float = 1.5
        //Creating an anchor on the horizontal plane for the grid
        let anchor = AnchorEntity(plane: .horizontal)
        
        //Loading the grid one circle at a time
        for row in 0..<model.gridSize {
            //3D array used. We will keep track of each row of circles and then add the circle to individual row. Then, the whole row will be added to our myGrid 3D array
            var individualRow: [TouchGrassModel.GridCircle] = []
            
            for col in 0..<model.gridSize {
                let fullCircle = generateCircle(innerColor: .red)
                
                //setting the position for each circle in the grid
                let x = (Float(col) - 1) * spacing
                let z = (Float(row) - 1) * spacing
                
                //This is the posistion relative to the anchor that I placed
                fullCircle.position = SIMD3(x, 0, z)
                
                //Adding the 3D object we created ot the anchor (RealityKit)
                anchor.addChild(fullCircle)
                
                //Wrapping the entity in a GridCircle so we can track its position
                let gridCircle = TouchGrassModel.GridCircle(entity: fullCircle, row: row, col: col)
                
                //Add each GridCircle to the row
                individualRow.append(gridCircle)
            }
            
            //Add full row to the grid
            model.myGrid.append(individualRow)
        }
        
        //Inserting our anchor into our world
        scene.addAnchor(anchor)
        
        //Choosing a random circle to be the first checkpoint
        let greenCircle = model.myGrid.randomElement()!.randomElement()!
        setNewCheckpoint(currentCheckpoint: nil, nextCheckpoint: greenCircle)
        startCheckingForPlayerPosition()
        
    }
    
    func clearGrid () {
        let allAnchors = self.session.currentFrame?.anchors ?? []
        
        for currentAnchor in allAnchors {
            self.session.remove(anchor: currentAnchor)
        }
        
        scene.anchors.removeAll()
        
    }
    
    //This function is used to generate a entity that is a circle with a white ring around it in increase visibility of the circle. For this approach, we are making a parent entity that contains two children: 1 for the circle, 1 for the ring.
        //This is an important decision that we made as we need the circle and outer ring to be considered the same object when the player steps on top of them
        //Takes in a color that way we can use this function with another function to generate the green circle, simply by inserting the .green UIColor as the innerColor
        //ARKit Functionality
    func generateCircle (innerColor: UIColor) -> ModelEntity {
        
        //Compenent representing the whole circle
        let completeCircle = ModelEntity()

        //Generate inner circle
        let innerRadius: Float = 0.5
        let innerMaterial = SimpleMaterial(color: innerColor, isMetallic: false)
        let innerMesh = MeshResource.generateCylinder(height: 0.011, radius: innerRadius)
        let innerEntity = ModelEntity(mesh: innerMesh, materials: [innerMaterial])
        completeCircle.addChild(innerEntity)
        
        //Generate outer white ring
        let outerRadius = innerRadius * 1.2
        let outerMaterial = SimpleMaterial(color: .white, isMetallic: false) // Apple Documentation: ARKit converts the depth information into a series of vertices that connect to form a mesh
        let outerMesh = MeshResource.generateCylinder(height: 0.01, radius: outerRadius)
        let outerEntity = ModelEntity(mesh: outerMesh, materials: [outerMaterial])
        completeCircle.addChild(outerEntity)
        
        return completeCircle
    }
    
    //Set color of new checkpoint to green, and the old checkpoint to red
    func setNewCheckpoint(currentCheckpoint: TouchGrassModel.GridCircle?, nextCheckpoint: TouchGrassModel.GridCircle) {
        if let oldCircle = currentCheckpoint?.getEntity(),
           let innerCircle = oldCircle.children.first as? ModelEntity {
            innerCircle.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        }

        let newCircle = nextCheckpoint.getEntity()
        if let innerCircle = newCircle.children.first as? ModelEntity {
            innerCircle.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
        }

        model.currentCheckpoint = nextCheckpoint
    }
    
    func checkIfPlayerIsOnCheckpoint() {
        guard let checkpoint = model.currentCheckpoint else { return }

        let checkpointPosition = checkpoint.getEntity().position(relativeTo: nil) //nil -> asking for world coords relative to ar scene
        let cameraTransform = self.cameraTransform //4x4 matrix of entire camera pose
        let cameraPosition = cameraTransform.translation

        let dx = cameraPosition.x - checkpointPosition.x //how far camera and checkpoint are along horizontal plane (side-side)
        let dz = cameraPosition.z - checkpointPosition.z //(forward-back)
        let horizontalDistance = sqrt(dx * dx + dz * dz) //most difficult to compute (straight line distanceo on ground)

        if horizontalDistance < 0.5 {
            model.increaseScore()
            
            //haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            //play ding sound for audible feedback
            model.playSound(nameOfSound: "ding")


            let nextCheckpoint = model.chooseNextCheckpoint(currentCheckpoint: checkpoint)
            setNewCheckpoint(currentCheckpoint: checkpoint, nextCheckpoint: nextCheckpoint)
            
            model.currentCheckpoint = nextCheckpoint
        }
    }
    
    //    calls when grid is loaded to check player position
        func startCheckingForPlayerPosition() {
            model.checkTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.checkIfPlayerIsOnCheckpoint()
            }
        }
    
}
