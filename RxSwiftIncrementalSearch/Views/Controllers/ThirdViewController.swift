import UIKit
import RxSwift
import RxCocoa
import Library
import WikipediaAPI

final class ThirdViewController: UIViewController, UITextViewDelegate, DependencyInjectable {

    // MARK: - Outlet

    @IBOutlet private weak var titleTextField: UITextField! {
        didSet {
            titleTextField.font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
    @IBOutlet private weak var bodyTextView: UITextView! {
        didSet {
            bodyTextView.font = UIFont.systemFont(ofSize: 14)
        }
    }

    // MARK: - Property

    private let disposeBag = DisposeBag()
    private lazy var viewModel = ThirdViewModel(pageId: wikipediaSearch.pageid)

    // MARK: - DependencyInjectable

    private var wikipediaSearch: WikipediaSearch!

    struct Dependency {
        let wikipediaSearch: WikipediaSearch
    }

    static func make(withDependency dependency: Dependency) -> Self {
        // swiftlint:disable:next force_cast
        let vc = StoryboardScene.ThirdView.initialScene.instantiate() as! Self
        vc.wikipediaSearch = dependency.wikipediaSearch

        return vc
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        prepareNavigationItems()
        inatialData(wikipediaSearch)
        bind()

        setAccessibility()
    }
}

// MARK: - Public
extension ThirdViewController {

}

// MARK: - Private
private extension ThirdViewController {
    func prepareNavigationItems() {
    }

    func setAccessibility() {
        view.accessibilityIdentifier = "third_root_view"
    }

    func bind() {
        let input = ThirdViewModel.Input(
            viewWillAppearStream: rx.sentMessage(#selector(viewWillAppear(_:))).map { _ in }
        )
        let output = viewModel.transform(input: input)

        output.pageStream
            .bind(to: Binder(self) { (vc, data: WikipediaPage) in vc.configure(data) })
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

    func inatialData(_ pageData: WikipediaSearch) {
        Observable.just(pageData.title)
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        Observable.just("")
            .bind(to: bodyTextView.rx.text)
            .disposed(by: disposeBag)
    }

    func configure(_ pageData: WikipediaPage) {
        Observable.just(pageData.title)
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        let detailText = pageData.extract + "<br /><a href=\"\(pageData.url)\">詳細はこちら</a>"
        guard let data = detailText.data(using: .utf8) else {
            return
        }
        do {
            let option: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
            let attributedString = try NSMutableAttributedString(data: data, options: option, documentAttributes: nil)
            let font = bodyTextView.font?.withSize(14) ?? UIFont.systemFont(ofSize: 14)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.systemGray2,
                .paragraphStyle: paragraphStyle
            ]
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
            Observable.just(attributedString)
                .bind(to: bodyTextView.rx.attributedText)
                .disposed(by: disposeBag)
        } catch {
            Observable.just(pageData.extract)
                .bind(to: bodyTextView.rx.text)
                .disposed(by: disposeBag)
            print(error.localizedDescription)
        }
    }
}
