//
//  ViewController.swift
//  Quiz
//
//  Created by Lirim Imeri on 7/9/20.
//  Copyright © 2020 Lirim Imeri. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?
    
    @IBOutlet weak var questionCounter: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var btnOptionA: UIButton!
    @IBOutlet weak var btnOptionB: UIButton!
    @IBOutlet weak var btnOptionC: UIButton!
    @IBOutlet weak var btnOptionD: UIButton!
    
    let questions = QuestionBank()
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateQuestion()
        updateUI()
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("historyDatabase.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS History (score INTEGER, thetime TEXT, thedate TEXT)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
       
        print("Everything is fine")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAnswerClick(_ sender: UIButton) {
        if sender.tag == selectedAnswer {
            print("correct")
            score += 1
        } else {
            print("incorrect")
        }
        
        questionNumber += 1
        updateQuestion()
    }
    
    func updateQuestion() {
        if questionNumber < questions.list.count  {
            questionLabel.text = questions.list[questionNumber].question
            btnOptionA.setTitle(questions.list[questionNumber].optionA, for: UIControlState.normal)
            btnOptionB.setTitle(questions.list[questionNumber].optionB, for: UIControlState.normal)
            btnOptionC.setTitle(questions.list[questionNumber].optionC, for: UIControlState.normal)
            btnOptionD.setTitle(questions.list[questionNumber].optionD, for: UIControlState.normal)
            selectedAnswer = questions.list[questionNumber].correctAnswer
            
            updateUI()
        }
        else {
            let alert = UIAlertController(title: "Great!", message: "End of Quiz. Do you want to start another one?", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: {
                action in self.restartQuiz()
            })
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func restartQuiz()
    {
        score = 0
        questionNumber = 0

        updateQuestion()
    }
    
    func updateUI()
    {
        scoreLabel.text = "Score: \(score)"
        questionCounter.text = "\(questionNumber + 1)/\(questions.list.count)"
        
    }
    
    func createTable() {
//        let createTable = self.historyTable.create { (table) in
//            table.column(self.score)
//            table.column(self.time)
//
        }
    }
    
    func insertValues() {
        
    }
    
    func getData() {
        
    }


