//
//  ViewController.swift
//  My2048
//
//  Created by eyal avisar on 08/09/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//animation shows too much


import UIKit

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4 - 4, height: collectionView.frame.height / 4 - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if squaresContentHistory != squaresContent.description {
                getNewTileContent()
            }
            print(squaresContentHistory)
            print(squaresContent)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = .blue
        cell.pointsLabel.textColor = .yellow
        
        animateShift(cell: cell)
        cell.setup(cellNumber: indexPath.row)
        
        if squaresContent[indexPath.row] != 0 {
            cell.pointsLabel.text = String(squaresContent[indexPath.row])
            cell.pointsLabel.tintColor = .blue
        }
        return cell
    }

}

class ViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var numbersCollection: UICollectionView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    var squaresContent:[Int] = [] //Array(repeating: 0, count: 15)
    var squaresContentHistory = ""
    var endGoal = false
    var direction = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numbersCollection.delegate = self
        numbersCollection.dataSource = self
        
        // Swipe (right and left)
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        
        swipeUpGesture.direction = UISwipeGestureRecognizer.Direction.up
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeUpGesture)
        view.addGestureRecognizer(swipeDownGesture)
        
        run()
    }

    @IBAction func restartGame(_ sender: Any) {
        squaresContent = []
        squaresContentHistory = ""
        run()
        self.numbersCollection.reloadData()
    }
    
    func run() {
        endGoal = false
        squaresContent = Array(repeating: 0, count: 15)
        let value = Bool.random() ? 2 : 4
        squaresContent.append(value)
        squaresContent.shuffle()

    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {

        squaresContentHistory = squaresContent.description
        
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            direction = "right"
            shiftContentRight()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left
        {
            direction = "left"
            shiftContentLeft()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up
        {
            direction = "up"
            shiftContentUp()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down
        {
            direction = "down"
            shiftContentDown()
        }
        self.numbersCollection.reloadData()
        
        if !endGoal && squaresContent.contains(32) {
            let alert = UIAlertController(title: "Congratulations", message: "You have reached 2048", preferredStyle: .alert)
            let dismmisAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
            alert.addAction(dismmisAction)
            present(alert, animated: true)
            endGoal = true
        }
    }
    
    func shiftContentLeft()  {
        closeSquareContentGapsLeft()
        sumPointsLeft()
        closeSquareContentGapsLeft()
        print("swipe left")
    }
    
    func shiftContentRight() {
        closeSquareContentGapsRight()
        sumPointsRight()
        closeSquareContentGapsRight()
        print("swipe right")
    }
    
    func shiftContentUp() {
        closeSquareContentGapsUp()
        sumPointsUp()
        closeSquareContentGapsUp()
        print("swipe up")
    }
    
    func shiftContentDown() {
        closeSquareContentGapsDown()
        sumPointsDown()
        closeSquareContentGapsDown()
        print("swipe down")
    }
    
    func sumPointsRight() {
        var index = 15
        
        while index > 0 {
            if index % 4 > 0 && squaresContent[index] ==  squaresContent[index - 1] {
                squaresContent[index] *= 2
                squaresContent[index - 1] = 0
                
                if squaresContent[index] > 0 {
                    accumulatePoints(with: squaresContent[index])
                }
                
                index -= 2
                print(squaresContent)
                continue
            }
            index -= 1
        }
    }
    
    func closeSquareContentGapsRight() {
        var index = 0
        while index < 15 {
            if index % 4  < 3 && squaresContent[index] > 0 && squaresContent[index + 1] == 0 {
                squaresContent[index + 1] = squaresContent[index]
                squaresContent[index] = 0
                index = 0
                continue
            }
            index += 1
        }

    }
    
    func sumPointsLeft() {
        var index = 0
        
        while index < 15 {
            if index % 4 < 3 && squaresContent[index] ==  squaresContent[index + 1] {
                squaresContent[index + 1] *= 2
                squaresContent[index] = 0
                
                if squaresContent[index + 1] > 0 {
                    accumulatePoints(with: squaresContent[index])
                }
                
                index += 2
                print(squaresContent)
                continue
            }
            index += 1
        }
    }
    
    func closeSquareContentGapsLeft() {
        var index = 15
        while index > 0 {
            if index % 4  > 0 && squaresContent[index] > 0 && squaresContent[index - 1] == 0 {
                squaresContent[index - 1] = squaresContent[index]
                squaresContent[index] = 0
                index = 15
                continue
            }
            index -= 1
        }
    }

    func sumPointsDown() {
        var index = 15
        while index >= 4 {
            if squaresContent[index - 4] == squaresContent[index] {
                squaresContent[index] *= 2
                squaresContent[index - 4] = 0
                print("\(squaresContent), \(index)")
                
                if squaresContent[index] > 0 {
                    accumulatePoints(with: squaresContent[index])
                }
            }
            
            index -= 4
            if index < 4 && index != 0 {
                index += 11
            }
        }

    }
    
    func closeSquareContentGapsDown() {
        var index = 15
        while index >= 4 {
            if squaresContent[index - 4] != 0 && squaresContent[index] == 0{
                squaresContent[index] = squaresContent[index - 4]
                squaresContent[index - 4] = 0
                print(squaresContent)
                index = 15
                continue
            }
            
            index -= 4
            if index < 4 && index != 0 {
                index %= 4
                index += 11
            }
        }
    }
    
    func sumPointsUp() {
        var index = 0
        while index <= 11 {
            if squaresContent[index + 4] == squaresContent[index] {
                squaresContent[index] *= 2
                squaresContent[index + 4] = 0
                print("\(squaresContent), \(index)")
                if squaresContent[index] > 0 {
                    accumulatePoints(with: squaresContent[index])
                }
            }
            
            index += 4
            if index > 11 && index != 15 {
                index -= 11
            }
        }

    }
    
    func closeSquareContentGapsUp() {
        var index = 0
        while index <= 11 {
            if squaresContent[index] == 0 && squaresContent[index + 4] != 0{
                squaresContent[index] = squaresContent[index + 4]
                squaresContent[index + 4] = 0
                print(squaresContent)
                index = 0
                continue
            }
            
            index += 4
            if index > 11 && index != 15 {
                index %= 4
                index += 1
            }
        }
    }

    func accumulatePoints(with:Int) {
        var pointsLabelComponents = pointsLabel.text?.components(separatedBy: " ")
        
        let current = Int(pointsLabelComponents![1])
        pointsLabel.text = "Points \(current! + with)"
        
    }
    
    func getNewTileContent() {
        var insertedANumber = false
        while !insertedANumber {
            let index = Int.random(in: 0..<16)
            if squaresContent[index] == 0 {
                squaresContent[index] = Bool.random() ? 2 : 4
                insertedANumber = true
            }
        }
    }
    
    func animateShift(cell:CollectionViewCell) {
        if direction == "down" {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromTop, animations: {
                cell.backgroundColor = .blue
                cell.pointsLabel.textColor = .yellow
            },
            completion: nil)
        }
        else if direction == "up" {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromBottom, animations: {
                cell.backgroundColor = .blue
                cell.pointsLabel.textColor = .yellow
            },
            completion: nil)
        }
        else if direction == "left" {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromRight, animations: {
                cell.backgroundColor = .blue
                cell.pointsLabel.textColor = .yellow
            },
            completion: nil)
        }
        else if direction == "right" {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromLeft, animations: {
                cell.backgroundColor = .blue
                cell.pointsLabel.textColor = .yellow
            },
            completion: nil)
        }
    }
}

