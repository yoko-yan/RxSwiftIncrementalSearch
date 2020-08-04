import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import Library
import WikipediaAPI

final class FirstViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Property

    private let disposeBag = DisposeBag()
    private let viewModel = FirstViewModel()
    private let dataSource = DataSource()
    private var refreshControl = UIRefreshControl()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        prepareNavigationItems()
        prepare()
        bind()
    }
}

// MARK: - Public
extension FirstViewController {

}

// MARK: - Private
private extension FirstViewController {
    func prepareNavigationItems() {
    }

    func prepare() {
        tableView.estimatedRowHeight = 5
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
    }

    func bind() {

        let input = FirstViewModel.Input(
            viewDidReachBottom: tableView.rx.reachedBottom().asObservable(),
            pullToRefreshTrigger: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            incrementalSearchTrigger: searchBar.rx.text.orEmpty.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.searchStream
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        do {
            func canUseRefreshControl(_ vc: Self, can: Bool) {
                if can {
                    if !vc.refreshControl.isDescendant(of: vc.tableView) {
                        vc.tableView.addSubview(vc.refreshControl)
                    }
                } else {
                    vc.refreshControl.removeFromSuperview()
                }
            }
            let binder = Binder(self) { (vc, isEnable: Bool) in
                guard let vc = vc as? Self else { return }
                canUseRefreshControl(vc, can: isEnable)
            }

            output.searchStream
                .map { $0.count > 0 }
                .bind(to: binder )
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

        do {
            let binder = Binder(self) { (vc, wikipediaSearch: WikipediaSearch) in
                vc.transitionToNextView(wikipediaSearch)
                vc.searchBar.resignFirstResponder()
            }

            tableView.rx.modelSelected(WikipediaSearch.self)
                .bind(to: binder)
                .disposed(by: disposeBag)
        }

        output.loading
            .bind(onNext: { $0 ? LoadingIndicator.show() : LoadingIndicator.dismiss() })
            .disposed(by: disposeBag)

        output.refreshing
            .bind(to: refreshControl.rx.isRefreshing )
            .disposed(by: disposeBag)
    }

    func transitionToNextView(_ wikipediaSearch: WikipediaSearch) {
        let dependency = ThirdViewController.Dependency(wikipediaSearch: wikipediaSearch)
        let vc = ThirdViewController.make(withDependency: dependency)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
private class DataSource: NSObject, UITableViewDataSource {

    typealias Element = [WikipediaSearch]
    var items: [WikipediaSearch] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FirstTableViewCell
        let element = items[indexPath.row]
        cell.configure(element)

        return cell
    }
}

extension DataSource: RxTableViewDataSourceType {
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource.items = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}

extension DataSource: SectionedViewDataSourceType {
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.row]
    }
}

// MARK: - UISearchBarDelegate
extension FirstViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != nil else {
            return
        }

    }
}
