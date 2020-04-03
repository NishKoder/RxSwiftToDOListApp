//
//  TaskListVC.swift
//  TodoTestApp
//
//  Created by Nishant Gupta on 03/04/20.
//  Copyright © 2020 Nishant Gupta. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class TaskListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var prioritySC : UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filterTask = [Task]()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTask.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filterTask[indexPath.row].title
        return cell
       }
       
    @IBAction func priorityValueChanged(segmentedControll: UISegmentedControl){
        let priority = Priority(rawValue: self.prioritySC.selectedSegmentIndex - 1)
        self.filteringTask(by: priority)
        self.updateTableView()
        
    }
    private func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC =  segue.destination as? UINavigationController,
            let addTVC = navC.viewControllers.first as? AddNewTaskVC else {
                fatalError("AddNewTaskVC not called")
        }
        addTVC.takeSubjectObservale.subscribe(onNext: { [unowned self] task in
            let priority = Priority(rawValue: self.prioritySC.selectedSegmentIndex - 1)
            var existingTask = self.tasks.value
            existingTask.append(task)
            self.tasks.accept(existingTask)
            self.filteringTask(by: priority)
            }).disposed(by: disposeBag)
    }
    private func filteringTask(by priority:Priority?){
        if priority == nil {
            self.filterTask = self.tasks.value
            self.updateTableView()
        } else {
        self.tasks.map { tasks in
            return tasks.filter { $0.priority == priority! }
        }.subscribe(onNext: { [weak self] tasks in
            self?.filterTask = tasks
            self?.updateTableView()
        }).disposed(by: disposeBag)
    }
    }
}
