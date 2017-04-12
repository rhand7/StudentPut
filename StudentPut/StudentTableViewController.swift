//
//  StudentTableViewController.swift
//  StudentPut
//
//  Created by handje on 4/12/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - IB Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        StudentController.post(studentWithName: name) { (success) in
            guard success else { return }    //just guarding not unwrapping
            DispatchQueue.main.async {
                self.nameTextField.text = ""
                self.nameTextField.resignFirstResponder()
                self.fetchStudents()
            }
        }
    }
    
    // MARK: - Internal Properties
    
    var students = [Student]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func fetchStudents() {
        StudentController.fetchStudents { (students) in
            self.students = students
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStudents()
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        let student = students[indexPath.row]
        cell.textLabel?.text = student.name 
        
        return cell
    }
}
