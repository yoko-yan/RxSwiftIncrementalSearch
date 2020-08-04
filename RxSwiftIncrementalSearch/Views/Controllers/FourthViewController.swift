import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import Library
import WikipediaAPI

final class FourthViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet var tableView: UITableView!

    // MARK: - Property

    private let disposeBag = DisposeBag()
    private lazy var viewModel = FourthViewModel()
    private let dataSource = DataSource()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        prepareNavigationItems()
        prepareTableView()
        bind()
    }
}

// MARK: - Public
extension FourthViewController {

}

// MARK: - Private
private extension FourthViewController {
    func prepareNavigationItems() {
    }

    func prepareTableView() {
    }

    func bind() {
        let input = FourthViewModel.Input(
            viewWillAppearStream: rx.sentMessage(#selector(viewWillAppear(_:))).map { _ in }
        )
        let output = viewModel.transform(input: input)

        output.searchStream
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FourthTableViewCell
        let element = items[indexPath.row]
        cell.textLabel?.rx.text.onNext(element.title)

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
