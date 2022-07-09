//
//  ViewController.swift
//  DocScanner
//
//  Created by Ashish Maurya on 20/03/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Outlet..
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Test content..
    fileprivate var items: [String] = [
    "0",
    "alexdesk",
    "alexItem",
    "alexroad",
    "alexbox",
    "alexloke",
    "alexshoes",
    "alexbed",
    "This is the name of king vovovo"
    ]
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    func configureCollectionView(){
        collectionView.register(UINib(nibName: "CellDocument", bundle: .main), forCellWithReuseIdentifier: "CellDocument")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.dragDelegate = self
        self.collectionView.dropDelegate = self
    }
}

//MARK:- Delegates
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellDocument", for: indexPath) as? CellDocument {
            cell.backgroundColor = .white
            cell.updateValue(text: items[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


extension ViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move{
            reorderItems(coordinate: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    
    fileprivate func reorderItems(coordinate: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
        
        if let item = coordinate.items.first, let sourceIndexPath = item.sourceIndexPath{
         
            collectionView.performBatchUpdates ({
                self.items.remove(at: sourceIndexPath.item)
                self.items.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                
            }, completion: nil);

            coordinate.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag{
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}
