//
//  EditProfileViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 8.10.22.
//

import UIKit
import SwiftyKeychainKit

class EditProfileViewController: UIViewController {
    
    var profile: User? = nil
    
    // Table
    var tableView = UITableView()
    var tableModel: [SettingsMenuModel] = [SettingsMenuModel(header: "Profile", placeholder: ["First name", "Last name", "Username", "Email"], tags: [0, 1, 2, 3]),
                                           SettingsMenuModel(header: "Location", placeholder: ["City"], tags: [4]),
    ]
    
    lazy var saveBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        return barButtonItem
    }()
    
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var location: String?
    
    // Keychain
    let keychain = Keychain(service: "storage")
    let accessTokenKey = KeychainKey<String>(key: "key")
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        let rowsInSection = tableModel[section].tags?.count
        return rowsInSection!
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
        
        cell.selectionStyle = .none
        cell.titleTextField.tag = (tableModel[indexPath.section].tags?[indexPath.row])!
        cell.placeholder = tableModel[indexPath.section].placeholder?[indexPath.row]
        cell.titleTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.titleTextField.text = profile?.firstName
            case 1:
                cell.titleTextField.text = profile?.lastName
            case 2:
                cell.titleTextField.text = profile?.username
            default:
                cell.titleTextField.text = profile?.email
            }
        default:
            cell.titleTextField.text = profile?.location
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
        
        if let text = firstName {
            profile?.firstName = text
            print(text)
        }
        if let text = lastName {
            profile?.lastName = text
            print(text)
        }
        if let text = username {
            profile?.username = text
            print(text)
        }
        if let text = email {
            profile?.email = text
            print(text)
        }
        if let text = location {
            profile?.location = text
            print(text)
        }
        
        let token = try? keychain.get(accessTokenKey)
        if  let token = token {
            navigationController?.isNavigationBarHidden = false
            let url = "https://api.unsplash.com/me?access_token=\(token)"
            ProfileManager.shared.updateProfile(with: url, profile: profile!) { result in
                switch result {
                case .success(let profile):
                    self.profile = profile
                    if profile.username == nil {
                        self.showErrorAlert(title: "", message: "Username has already been taken")
                    }
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self.displayError(error)
                    print(error)
                }
            }
        }
    }
    
    @objc func valueChanged(_ textField: UITextField){
        print("TextField: \(String(describing: textField.text)) Tag : \(textField.tag)")
        
        switch textField.tag {
        case TextFieldData.firstName.rawValue:
            firstName = textField.text
            
        case TextFieldData.lastName.rawValue:
            lastName = textField.text
            
        case TextFieldData.username.rawValue:
            username = textField.text
            
        case TextFieldData.email.rawValue:
            email = textField.text
            
        case TextFieldData.location.rawValue:
            location = textField.text
            
        default:
            break
        }
    }
}

// MARK: - Network
extension EditProfileViewController {
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Ensure you are connected to the internet. Please try again."
        }
        return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        
        // Don't present one error if another has already been presented
        if !errorAlert.isBeingPresented {
            present(errorAlert, animated: true, completion: nil)
        }
    }
}
