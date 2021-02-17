import Foundation
import RxSwift
import RxCocoa
import WikipediaAPI

struct FirstViewModel {

    // MARK: - Property

    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    private let dependencies: Dependencies
    private let scheduler: SchedulerType

    init(dependencies: Dependencies = DependenciesImpl(), scheduler: SchedulerType = MainScheduler.instance) {
        self.dependencies = dependencies
        self.scheduler = scheduler
    }
}

// MARK: - Public
extension FirstViewModel {

}

// MARK: - Private
private extension FirstViewModel {
    struct RequestParameter {
        let word: String
        let offset: Int
    }
}

extension FirstViewModel: ViewModelType {
    struct Input {
        let viewDidReachBottom: Observable<Void>
        let pullToRefreshTrigger: Observable<Void>
        let incrementalSearchTrigger: Observable<String>
    }

    struct Output {
        let loading: Observable<Bool>
        let refreshing: Observable<Bool>
        let searchStream: Observable<[WikipediaSearch]>
        let error: Observable<Error>
    }

    func transform(input: Input) -> Output {
        let session = dependencies.session

        let requestParameterRelay = BehaviorRelay<RequestParameter>(value: RequestParameter(word: "", offset: 0))
        let continueRelay = BehaviorRelay<WikipediaSearchResponse.Continue?>(value: nil)

        let incrementalSearchTrigger = input.incrementalSearchTrigger
            .debounce(.milliseconds(300), scheduler: scheduler)
            .filter { $0.count >= 3 }
            .distinctUntilChanged()
            .map { RequestParameter(word: $0, offset: 0) }
            .share()

        let reloadRequestTrigger = input.pullToRefreshTrigger
            .withLatestFrom(requestParameterRelay.compactMap { $0 })
            .map { RequestParameter(word: $0.word, offset: 0) }
            .share()

        let paginationRequestTrigger = input.viewDidReachBottom
            .withLatestFrom(Observable.combineLatest(requestParameterRelay.compactMap { $0 }, continueRelay.compactMap { $0 }) )
            .map { RequestParameter(word: $0.word, offset: $1?.sroffset ?? 0) }
            .share()

        let load = PublishRelay.merge(
                incrementalSearchTrigger,
                reloadRequestTrigger,
                paginationRequestTrigger
            )
            .filter { !$0.word.isEmpty }
            .throttle(.milliseconds(300), latest: false, scheduler: scheduler)
            .share()

        load
            .bind(to: requestParameterRelay)
            .disposed(by: disposeBag)

        let sequence = load
            .flatMapLatest { arg -> Observable<Event<WikipediaSearchResponse>> in
                return session.rx.send(WikipediaSearchRequest(word: arg.word, offset: arg.offset))
                    .asObservable()
                    .materialize()
            }
            .share()

        let apiResponseStream = sequence.compactMap { $0.event.element }.share()
        apiResponseStream
            .map { $0.continue }
            .bind(to: continueRelay)
            .disposed(by: disposeBag)

        let searchStream = apiResponseStream
            .scan([]) { $1.continue?.sroffset == $1.query.search.count || $1.continue == nil ? $1.query.search : $0 + $1.query.search }
            .share(replay: 1)

        let loading = PublishRelay.merge(load.map { _ in true }, sequence.map { _ in false }).startWith(false)
        let refreshing = PublishRelay.merge(reloadRequestTrigger.map { _ in true }, sequence.map { _ in false }).startWith(false)
        let error = sequence.errors().share()

        return Output(
            loading: loading,
            refreshing: refreshing,
            searchStream: searchStream,
            error: error
        )
    }
}
