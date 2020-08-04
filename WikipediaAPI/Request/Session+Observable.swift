import APIKit
import RxSwift

extension Session: ReactiveCompatible {
}

extension Reactive where Base: Session {
    public func send<T: Request>(_ request: T) -> Single<T.Response> {
        return Single.create { [weak base] singleEvent in
            let task = base?.send(request) { result in
                switch result {
                case .success(let response):
                    singleEvent(.success(response))
                case .failure(let error):
                    singleEvent(.error(error))
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
