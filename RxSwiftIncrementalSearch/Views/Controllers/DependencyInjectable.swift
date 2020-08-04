protocol DependencyInjectable {
    associatedtype Dependency
    static func make(withDependency dependency: Dependency) -> Self
}
