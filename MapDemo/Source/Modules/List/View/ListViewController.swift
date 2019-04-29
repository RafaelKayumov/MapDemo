//
//  ListViewController.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, StoryboardBased {

    var output: ListViewOutput!
    private var presentables = [GeoObjectPresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension

        output.onViewReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        output.onWillAppear()
        output.triggerObjectsRefresh()
    }
}

extension ListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentables.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectCell.self), for: indexPath)
        if let objectCell = cell as? ObjectCell {
            let presentable = presentables[indexPath.row]
            objectCell.configureWith(presentable)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.onObjectSelectFor(indexPath.row)
    }
}

extension ListViewController: ListViewInput {

    func display(_ presentables: [GeoObjectPresentable]) {
        self.presentables = presentables
        refreshObjects()
    }

    func refreshObjects() {
        tableView.reloadData()
    }
}
