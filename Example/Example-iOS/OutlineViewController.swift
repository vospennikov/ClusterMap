//
//  OutlineViewController.swift
//  Example
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import UIKit
import SwiftUI

final class OutlineViewController: UIViewController {
    private enum Section {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private lazy var dataSource: DataSource = makeDataSource()
    private lazy var tableView = UITableView(frame: view.bounds, style: .plain)
    
    private class Item: Hashable {
        private let identifier = UUID()
        let title: String
        let viewController: MapController.Type
        
        init(title: String, viewController: MapController.Type) {
            self.title = title
            self.viewController = viewController
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        applySnapshot(animatingDifferences: false)
    }
    
    private lazy var items: [Item] = {[
        Item(title: "MKMapView with default clustering", viewController: DefaultMapViewController.self),
        Item(title: "MKMapView with ClusterMap", viewController: ClusterMapViewController.self),
    ]}()
    
    private func configureCollectionView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        tableView.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
    }
    
    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = item.title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension OutlineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destinationViewController = cell.viewController
        let mapContainer = MapContainerViewController(
            mapController: destinationViewController.init(initialRegion: .sanFrancisco)
        )
        navigationController?.pushViewController(mapContainer, animated: true)
    }
}

struct OutlineViewController_PreviewProvider: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: OutlineViewController())
            .preview
    }
}
