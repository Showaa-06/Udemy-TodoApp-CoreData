//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 鈴木彰悟 on 2022/12/21.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    //segueを実行する直前にトリガーされる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        //もし複数のsegueが存在する場合if文を使用する

        //選択されたセルに対応するカテゴリーを取得//
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]

        }

    }

    func  saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
        
    }
        func loadCategories() {
            let request : NSFetchRequest<Category> = Category.fetchRequest()
            do {
                categories = try context.fetch(request)
            } catch {
                print("Error loading categories \(error)")
            }
            
            tableView.reloadData()
        }
        
 @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { action in
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categories.append(newCategory)
                
                self.saveCategories()
            }
            
            alert.addAction(action)
            alert.addTextField { field in
                textField = field
                textField.placeholder = "Add a New category"
            }
            
            present(alert, animated: true, completion: nil)
            
        }
    }
