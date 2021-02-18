//
//  ViewController.swift
//  FBT2
//
//  Created by 황지웅 on 2021/02/18.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    let db = Database.database().reference()
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var changeValue: UILabel!
    var customers: [Customer] = []
    func deleteCustomers() {
        db.child("customers").removeValue()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        updateLabel()
        //saveBasicTypes()
        //saveCustomers()
        //fetchCustomer()
        //updateBasicType()
        //deleteCustomers()
        
    }

    func updateLabel(){
        db.child("firstData").observeSingleEvent(of: .value){snapshot in
            print("---> \(snapshot)")
            let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
    
    @IBAction func createCustomer(_ sender: Any) {
        saveCustomers()
    }
    
    @IBAction func fetchCustomer(_ sender: Any) {
        fetchCustomer()
    }
    
    @IBAction func updateCustomer(_ sender: Any) {
        updateCustomers()
    }
   
    @IBAction func deleteCustomer(_ sender: Any) {
        deleteCustomers()
        //deleteBasicType()
    }
}
extension ViewController{
    func updateCustomers(){
        guard customers.isEmpty == false else {return}
        customers[0].name = "min"
        
        let dictionary = customers.map{$0.toDictionary}
        db.updateChildValues(["customers":dictionary])
        
    }
    
}

extension ViewController{
    func saveBasicTypes(){
        db.child("int").setValue(3)
        db.child("double").setValue(3.5)
        db.child("str").setValue("string value - Hello Everyone")
        db.child("array").setValue(["a","b","C"])
        db.child("dict").setValue(["id": "anyID"])
    }
    
    func saveCustomers(){
        // 책가게
        // User Saveing
        // Model Customer + Book
        let books = [Book(title: "good to great", author: "Someone"),Book(title: "Hacking Growth", author: "Robert Martin")]
        let customer1 = Customer(id: "\(Customer.id)", name: "Son", books: books)
        Customer.id += 1
        let customer2 = Customer(id: "\(Customer.id)", name: "Dale", books: books)
        Customer.id += 1
        let customer3 = Customer(id: "\(Customer.id)", name: "Kane", books: books)
        Customer.id += 1
        
        db.child("customers").child(customer1.id).setValue(customer1.toDictionary)
        db.child("customers").child(customer2.id).setValue(customer2.toDictionary)
        db.child("customers").child(customer3.id).setValue(customer3.toDictionary)
    }
}
//Read Data
extension ViewController{
    func fetchCustomer(){
        db.child("customers").observeSingleEvent(of: .value){ snapshot in
            print("--> \(snapshot.value)")
            do{
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                
                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)
                self.customers = customers
                DispatchQueue.main.async {
                    self.changeValue.text = "number of Customer : \(customers.count)"
                }
                
                print("--->customer: \(customers.count) : ")
            }catch let error{
                print("-->error : \(error.localizedDescription)")
            }
        }
    }
}

extension ViewController{
    func updateBasicType(){
        db.updateChildValues(["int":10])
        db.updateChildValues(["double":10.123])
        db.updateChildValues(["str": "Fuck Man"])
//        db.child("int").setValue(123)
//        db.child("double").setValue(3213)
//        db.child("str").setValue("str value - EH")
    }
    
    func deleteBasicType(){
        db.child("int").removeValue()
        db.child("double").removeValue()
        db.child("str").removeValue()
    }
}
struct Customer:Codable{
    let id: String
    var name: String
    let books: [Book]
    
    var toDictionary : [String: Any]{
        let booksArray = books.map{$0.toDictionary}
        let dict: [String: Any] = ["id":id, "name":name, "books":booksArray]
        return dict
    }
    static var id: Int = 0
    
}
struct Book:Codable{
    let title: String
    let author: String
    var toDictionary : [String: Any]{
        let dict: [String: Any] = ["title": title, "author": author]
        return dict
    }
}
