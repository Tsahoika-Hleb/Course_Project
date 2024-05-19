import UIKit

final class ChatsViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    private let viewModel: ChatsViewModel?

    // MARK: - Lyfe cycle
    init(viewModel: ChatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadChats()
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
    }
    
    private func loadChats() {
        viewModel?.loadChats()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel else { return }
        // Обработка выбора чата
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = viewModel.sortedChats[indexPath.row]
        // Откройте экран чата
        print("Selected chat with \(chat.name)")
    }
}

// MARK: - UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.sortedChats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        let chat = viewModel.sortedChats[indexPath.row]
        cell.configure(with: chat)
        return cell
    }
}
