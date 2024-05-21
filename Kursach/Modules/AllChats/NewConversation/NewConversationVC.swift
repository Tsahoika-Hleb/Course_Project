import UIKit
import SnapKit

class NewConversationVC: UIViewController {

    private var viewModel: ChatsViewModel
    
    // MARK: - UI Properties
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        tableView.rowHeight = 55
        return tableView
    }()
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.searchedUsers = []
    }
    
    init(viewModel: ChatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        viewModel.bindSearchedUser = {
            self.tableView.reloadData()
        }
        searchBar.delegate = self
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate
extension NewConversationVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let text = searchBar.text else {
            return
        }
        
        viewModel.findUsers(with: text)
    }
}

// MARK: - UITableViewDelegate
extension NewConversationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDataSource
extension NewConversationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserTableViewCell",
            for: indexPath
        ) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.searchedUsers[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}
