//
//  RiwayatTransaksiManager.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation
import CoreData


class RiwayatTransaksiManager: NSObject {
    static let shared = RiwayatTransaksiManager()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BNIAssesment")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    
    func saveRiwayatTransaksi(transaction: Transaksi) {
        let userEntity = NSEntityDescription.entity(forEntityName: "RiwayatTransaksi", in: managedContext)
        
        let insert = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        insert.setValue(transaction.id, forKey: "id")
        insert.setValue(transaction.merchant, forKey: "merchant")
        insert.setValue(transaction.bank, forKey: "bank")
        insert.setValue(transaction.nominal, forKey: "nominal")
        
        do {
            try managedContext.save()
        } catch let err {
            print(err)
        }
    }
    
    func getRiwayatTransaksi() -> [Transaksi] {
        var list = [Transaksi]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RiwayatTransaksi")
        
        let userEntity = NSEntityDescription.entity(forEntityName: "RiwayatTransaksi", in: managedContext)
        fetchRequest.entity = userEntity
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach{ data in
                list.append(
                    Transaksi(
                        bank: (data.value(forKey: "bank") as? String) ?? "",
                        id: (data.value(forKey: "id") as? String) ?? "",
                        merchant: (data.value(forKey: "merchant") as? String) ?? "",
                        nominal: (data.value(forKey: "nominal") as? Int) ?? 0
                    )
                )
            }
        } catch let err {
            print(err)
        }
        
        return list
    }
}
