import Foundation
import RxSwift
import RxCocoa

struct SecondViewModel {

    // MARK: - Property

    private let disposeBag = DisposeBag()

    private let items: Observable<[String]> = Observable.just(["Apple", "Banana", "Orange"])

    // MARK: - Initialize

    private let dependencies: Dependencies
    private let scheduler: SchedulerType

    init(dependencies: Dependencies = DependenciesImpl(), scheduler: SchedulerType = MainScheduler.instance) {
        self.dependencies = dependencies
        self.scheduler = scheduler
    }
}

// MARK: - Public
extension SecondViewModel {

}

// MARK: - Private
private extension SecondViewModel {

}

extension SecondViewModel: ViewModelType {
    struct Input {
        let viewWillAppearStream: Observable<Void>
    }

    struct Output {
        let loading: Observable<Bool>
        let searchStream: Observable<[String]>
        let error: Observable<Error>
    }

    func transform(input: Input) -> Output {

        let load = input.viewWillAppearStream.take(1) // 1 is a first
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .share()

        let sequence = load
            .flatMapLatest { self.items }
            .materialize()
            .share()

        let elements = sequence.elements().share()
        let loading = PublishRelay.merge(load.map { _ in true }, sequence.map { _ in false })
        let error = sequence.errors().share()

        return Output(
            loading: loading,
            searchStream: elements,
            error: error
        )
    }
}
