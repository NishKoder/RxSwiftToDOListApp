//
//  AddNewTaskVC.swift
//  TodoTestApp
//
//  Created by Nishant Gupta on 03/04/20.
//  Copyright © 2020 Nishant Gupta. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddNewTaskVC: UIViewController {
    private let taskSubject = PublishSubject<Task>()
    var takeSubjectObservale: Observable<Task> {
        return taskSubject.asObserver()
    }
    @IBOutlet weak var prioritySegmentControll: UISegmentedControl!
    @IBOutlet weak var taskTitleTextFirld: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func save() {
        guard let priority = Priority(rawValue: self.prioritySegmentControll.selectedSegmentIndex),
            let title = self.taskTitleTextFirld.text else{
                return
        }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
        
    }
}
