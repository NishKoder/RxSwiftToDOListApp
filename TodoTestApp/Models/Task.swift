//
//  Task.swift
//  TodoTestApp
//
//  Created by Nishant Gupta on 03/04/20.
//  Copyright © 2020 Nishant Gupta. All rights reserved.
//

import Foundation
enum Priority: Int {
    case high
    case medium
    case low
}
struct Task {
    let title: String
    let priority: Priority
}
