//
//  EditProfileViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 8.10.22.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // Table
    var tableView = UITableView()
    var tableModel: [SettingsMenuModel] = [SettingsMenuModel(header: "Profile", numberOfCell: 4),
                                           SettingsMenuModel(header: "Location", numberOfCell: 1),
                                           SettingsMenuModel(header: "Website", numberOfCell: 1),
    ]
    
    lazy var saveBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = saveBarButton
    }
}

extension EditProfileViewController {
    func style() {
        view.backgroundColor = .backgroundColor
        
        // Table
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .backgroundColor
        tableView.register(EditCell.self, forCellReuseIdentifier:  EditCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = EditCell.rowHeight
    }
    
    func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableModel.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableModel[section].header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsInSection = tableModel[section].numberOfCell
        return rowsInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.frame = CGRect(x: 32, y: 10, width: tableView.frame.size.width - 48, height: 28)
        label.textColor = UIColor(red: 0.282, green: 0.282, blue: 0.29, alpha: 1)
        label.text = tableModel[section].header
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditCell.reuseID, for: indexPath) as? EditCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Name"
            case 1:
                cell.titleLabel.text = "Surname"
            case 2:
                cell.titleLabel.text = "Username"
            default:
                cell.titleLabel.text = "email@gmail.ru"
            }
        case 1:
            cell.titleLabel.text = "City"
        default:
            cell.titleLabel.text = "Website_Website_Website_Website_Website_Website"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(getter: UIView.tintColor))){
            let cornerRadius: CGFloat = 10.0
            cell.backgroundColor = .clear
            let layer: CAShapeLayer = CAShapeLayer()
            let path: CGMutablePath = CGMutablePath()
            let bounds: CGRect = cell.bounds.insetBy(dx: 16.0, dy: 0.0)
            var addLine: Bool = false
            if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
                path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
            } else if indexPath.row == 0 {
                path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
                path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                addLine = true
            } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            } else {
                path.addRect(bounds)
                addLine = true
            }
            layer.path = path
            layer.fillColor = UIColor.backViewColor.cgColor
            if addLine {
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat = 2.0 / UIScreen.main.scale
                lineLayer.frame = CGRect(x: bounds.minX + 0.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
                lineLayer.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1).cgColor
                layer.addSublayer(lineLayer)
            }
            let testView: UIView = UIView(frame: bounds)
            testView.layer.insertSublayer(layer, at: 0)
            testView.backgroundColor = .clear
            cell.backgroundView = testView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}

// MARK: - Actions
extension EditProfileViewController {
    
    @objc func saveTapped(sender: UIButton) {
        //TODO: - Add action functionality
        print("Save")
    }
}
