//
//  ViewController.swift
//  TableViewProgrammatically
//
//  Created by Jack Ngai on 5/23/17.
//  Copyright © 2017 Jack Ngai. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {
    
    var items = ["Item 1", "Item 2", "Item 3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My TableView"
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellID")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerID")
        
        tableView.sectionHeaderHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(insert))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batch Insert", style: .plain, target: self, action: #selector(insertBatch))
    }
    
    func insertBatch(){
        
        var oddIndexPaths = [IndexPath]()
        var evenIndexPaths = [IndexPath]()
        for i in items.count...items.count + 5 {
            items.append("Item \(i + 1)")
            if i % 2 == 0{
                evenIndexPaths.append(IndexPath(row: i, section: 0))
            } else {
                oddIndexPaths.append(IndexPath(row: i, section: 0))
            }
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: oddIndexPaths, with: .left)
        tableView.insertRows(at: evenIndexPaths, with: .right)
        tableView.endUpdates()
        
        
    }
    
    func insert(){
        items.append("Item \(items.count + 1)")
        
        let insertionIndexPath = IndexPath(row: items.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath], with: .top)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! MyCell
        myCell.nameLabel.text = items[indexPath.row]
        myCell.myTableViewController = self
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerID")
    }
    
    func deleteCell(cell: MyCell){
        
        if let deletionIndexPath = tableView.indexPath(for: cell){
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .fade)
        }
        
        
    }
}

class Header: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My Header"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    func setupViews(){
        
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
    }
    
}

class MyCell: UITableViewCell {
    
    var myTableViewController: MyTableViewController?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func setupViews(){
        
        addSubview(nameLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
        
    }
    
    func handleAction(){
        
        myTableViewController?.deleteCell(cell: self)
        
    }
    
}
