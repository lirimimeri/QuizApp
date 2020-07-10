//
//  Question.swift
//  Quiz
//
//  Created by Lirim Imeri on 7/10/20.
//  Copyright © 2020 Lirim Imeri. All rights reserved.
//

import Foundation

class Question {
    let question: String
    let optionA: String
    let optionB: String
    let optionC: String
    let optionD: String
    let correctAnswer: Int
    
    init(questionText: String, choiceA: String, choiceB: String, choiceC: String, choiceD: String, correctChoice: Int) {
        question = questionText
        optionA = choiceA
        optionB = choiceB
        optionC = choiceC
        optionD = choiceD
        correctAnswer = correctChoice
    }
}
