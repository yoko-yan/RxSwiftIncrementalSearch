import Foundation

func asyncAfter(_ interval: DispatchTimeInterval = DispatchTimeInterval.seconds(0), execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1 + interval) {
        work()
    }
}
