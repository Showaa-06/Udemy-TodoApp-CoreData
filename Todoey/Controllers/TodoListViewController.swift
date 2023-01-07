//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()

    var selectedCategory : Category? {
        //選択されたカテゴリーに値が設定されるとすぐに発生
            didSet {
        loadItems()
    }
}

        
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //AppDelegateへの問い合わせ
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell" , for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray.remove(at: indexPath.row)
       
        saveItem()
        
        //内部にあるはずのデータを再読み込みさせる
        tableView.reloadData()
        //点滅
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Creat new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
//MARK - Model Manupulation Methods
    func saveItem() {
       
        do {
            try context.save()
        } catch {
            print("Error saving context\(error)")
            
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
    //nameプロパティーが現在のselectedCategoryと一致しなければならないというフォーマット
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@"  , selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
            
        }
        
        do {
         itemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
}
//MARK - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //アイテム配列の全てのアイテムについて、アイテムのタイトルにこのテキストが
        // 含まれているものを探す
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //データベースへの問い合わせ方法を指定する述語を作成
        //request.predicate = predicate
        
        //データベースから戻ってきたデータを好きな順番で並べることができる
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //複数形のため配列を期待している
        // request.sortDescriptors = [sortDescriptr]
        
        loadItems(with: request, predicate: predicate)
        tableView.reloadData()
        
        //1.新しいリクエストを作成し
        //2.そのリクエストを修正し
        //3. loadItems関数に渡す
        //4. loadItems内でその要求を実行する
        
    }
    //searchBar内のテキストが変更されると、トリガー
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
//DispatchQueueにメインキーを取得してもらって、メインキューでこのメソッドを実行する
            DispatchQueue.main.async {
                          //キーボードを下げる
                searchBar.resignFirstResponder()
            }
        }
    }
}
