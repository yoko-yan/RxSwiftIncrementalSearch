import UIKit
import RxSwift
import RxCocoa
import Library
import WikipediaAPI

final class SecondViewController: UIViewController {

    // MARK: - Property

    private let disposeBag = DisposeBag()
    private let viewModel = SecondViewModel()
    private var itemsRelay = BehaviorRelay<[String]>(value: [])

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        prepareNavigationItems()
        prepareTableView()
        bind()
        setAccessibility()
    }
}

// MARK: - Public
extension SecondViewController {

}

// MARK: - Private
private extension SecondViewController {
    func prepareNavigationItems() {
    }

    func prepareTableView() {
    }

    func bind() {
        let input = SecondViewModel.Input(
            viewWillAppearStream: rx.sentMessage(#selector(viewWillAppear(_:))).map { _ in }
        )
        let output = viewModel.transform(input: input)

        output.searchStream
            .bind(to: tableView.rx.items) { (_, _, element) in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)

        output.searchStream
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)

        do {
            let binder = Binder(self) { (vc, indexPath: IndexPath) in
                let item = vc.itemsRelay.value[indexPath.row]
                vc.transitionToNextView(item)
            }

            tableView.rx.itemSelected
                .bind(to: binder)
                .disposed(by: disposeBag)
        }

        do {
            let binder = Binder(self) { (_, error: Error) in
                Log.error(error: error)
            }

            output.error
                .bind(to: binder)
                .disposed(by: disposeBag)
        }

        output.loading
            .bind(onNext: { $0 ? LoadingIndicator.show() : LoadingIndicator.dismiss() })
            .disposed(by: disposeBag)
    }

    func transitionToNextView(_ content: String) {
        let dependency = FifthViewController.Dependency(content: content)
        let vc = FifthViewController.make(withDependency: dependency)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITest
private extension SecondViewController {
    func setAccessibility() {
        view.accessibilityIdentifier = "second_root_view"
    }
}
