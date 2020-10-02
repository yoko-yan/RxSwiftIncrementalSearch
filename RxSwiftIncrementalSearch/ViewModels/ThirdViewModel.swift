import Foundation
import RxSwift
import RxCocoa
import WikipediaAPI

struct ThirdViewModel {

    // MARK: - Property

    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    private let dependencies: Dependencies
    private let scheduler: SchedulerType
    private let pageId: Int

    init(dependencies: Dependencies = DependenciesImpl(), scheduler: SchedulerType = MainScheduler.instance, pageId: Int) {
        self.dependencies = dependencies
        self.scheduler = scheduler
        self.pageId = pageId
    }
}

// MARK: - Public
extension ThirdViewModel {

}

// MARK: - Private
private extension ThirdViewModel {

}

extension ThirdViewModel: ViewModelType {
    struct Input {
        let viewWillAppearStream: Observable<Void>
    }

    struct Output {
        let loading: Observable<Bool>
        let pageStream: Observable<WikipediaPage>
        let error: Observable<Error>
    }

    func transform(input: Input) -> Output {
        let session = dependencies.session

        let pageId = Observable.just(self.pageId)

        let load = input.viewWillAppearStream.take(1) // 1 is a first
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .share()

        let sequence = load
            .withLatestFrom(pageId)
            .flatMapLatest { pageId -> Observable<WikipediaPageResponse> in
                return session.rx.send(WikipediaPageRequest(pageid: pageId))
                    .asObservable()}
            .materialize()
            .share()

        let elements = sequence.elements().share()
        let loading = PublishRelay.merge(load.map { _ in true }, sequence.map { _ in false })
        let error = sequence.errors().share()

        return Output(
            loading: loading,
            pageStream: elements.compactMap { $0.query.pages.first?.value },
            error: error
        )
    }
}
