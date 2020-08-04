import UIKit
import RxSwift
import RxCocoa
import WikipediaAPI

final class FifthViewController: UIViewController, DependencyInjectable {

    // MARK: - Property

    private let disposeBag = DisposeBag()
    private let viewModel = SecondViewModel()
    private var itemsRelay = BehaviorRelay<[String]>(value: [])

    private lazy var textView: UITextView = {
        let textView = UITextView()
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return textView
    }()

    // MARK: - DependencyInjectable

    private var content: String!

    struct Dependency {
        let content: String
    }

    static func make(withDependency dependency: Dependency) -> Self {
        // swiftlint:disable:next force_cast
        let vc = StoryboardScene.FifthView.initialScene.instantiate() as! Self
        vc.content = dependency.content

        return vc
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        prepareNavigationItems()
        prepareTextView()
        bind()
    }
}

// MARK: - Public
extension FifthViewController {

}

// MARK: - Private
private extension FifthViewController {
    private func prepareNavigationItems() {
    }

    private func prepareTextView() {
    }

    private func bind() {
        Observable.just(content)
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
}
