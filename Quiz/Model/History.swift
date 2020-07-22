//
//  History.swift
//  Quiz
//
//  Created by Lirim Imeri on 7/22/20.
//  Copyright © 2020 Lirim Imeri. All rights reserved.
//

import Foundation

class History {
    let score: Int
    let date: String
    let time: String
    
    init(score: Int, date: String, time: String) {
        self.score = score
        self.date = date
        self.time = time
    }
}
