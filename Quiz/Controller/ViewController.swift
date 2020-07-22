//
//  ViewController.swift
//  Quiz
//
//  Created by Lirim Imeri on 7/9/20.
//  Copyright © 2020 Lirim Imeri. All rights reserved.
//

import UIKit
import SQLite3

var list = [History]()

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
    var date = Date()
    var formatter = DateFormatter()
    let calendar = Calendar.current
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateQuestion()
        updateUI()
        openDatabase()
        createTable()
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
            insertValues()
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
        let createTableQuery = "CREATE TABLE IF NOT EXISTS History (score INTEGER, thetime TEXT, thedate TEXT);"
        
        sqlite3_exec(db, createTableQuery, nil, nil, nil)
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
    }
    
    func insertValues() {
        formatter.dateFormat = "dd.MM.yyyy"
        let datenow = formatter.string(from: date)
        let hour = String(calendar.component(.hour, from: date))
        let minutes = String(calendar.component(.minute, from: date))
        
        let timenow = hour + ":" + minutes
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO History (score, thetime, thedate) VALUES (?,?);"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, Int32(score))
        sqlite3_bind_text(stmt, 2, datenow, -1, nil)
        sqlite3_bind_text(stmt, 3, timenow, -1, nil)
        
    }
    
    func getData() {
        let query = "SELECT * FROM HISTORY"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
           print("\n")
            while (sqlite3_step(stmt) == SQLITE_ROW)
            {
                let score = Int(sqlite3_column_int(stmt, 0))
                let date = String(describing: sqlite3_column_text(stmt, 1))
                let time = String(describing: sqlite3_column_text(stmt, 2))
                
                list.append(History(score: Int(score), date: date, time: time))
            }
        }
    }
    
    func openDatabase() {
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("historyDatabase.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
    }


}
