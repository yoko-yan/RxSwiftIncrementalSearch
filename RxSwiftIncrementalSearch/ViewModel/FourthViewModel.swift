import Foundation
import RxSwift
import RxCocoa
import WikipediaAPI

struct FourthViewModel {

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
extension FourthViewModel {

}

// MARK: - Private
private extension FourthViewModel {

}

extension FourthViewModel: ViewModelType {
    struct Input {
        let viewWillAppearStream: Observable<Void>
    }

    struct Output {
        let loading: Observable<Bool>
        let searchStream: Observable<[WikipediaSearch]>
        let error: Observable<Error>
    }

    func transform(input: Input) -> Output {
        let session = dependencies.session

        let load = input.viewWillAppearStream.take(1) // 1 is a first
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .share()

        let sequence = load
            .flatMapLatest { _ in
                return session.rx.send(WikipediaSearchRequest(word: "swift"))
                    .asObservable()}
            .materialize()
            .share()

        let elements = sequence.elements().share()
        let loading = PublishRelay.merge(load.map { _ in true }, sequence.map { _ in false })
        let error = sequence.errors().share()

        return Output(
            loading: loading,
            searchStream: elements.map { $0.query.search },
            error: error
        )
    }
}
