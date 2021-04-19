//
//  Observable+Rx.swift
//

import Foundation
import RxSwift
import RxCocoa

// MARK: Optionals
// Credit to: https://github.com/RxSwiftCommunity/RxOptional

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

public extension ObservableType where Element: OptionalType {
    /**
     Unwrap and filter out nil values.
     - returns: Observbale of only successfully unwrapped values.
     */
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return Observable<Element.Wrapped>.empty()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }
    
    /**
     Unwraps optional and replace nil values with value.
     - parameter valueOnNil: Value to emit when nil is found.
     - returns: Observable of unwrapped value or nilValue.
     */
    func replaceNilWith(valueOnNil: Element.Wrapped) -> Observable<Element.Wrapped> {
        return self.map { element -> Element.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }
    
    /**
     Filter out non nil values.
     - returns: Observbale of only nil values.
     */
//    func filterNonNil() -> Observable<Void> {
//        return filter{ $0 == nil }.mapToVoid()
//    }
}

// MARK: Void

public extension ObservableType {
    
    /**
     Maps to void observable.
     - returns: Observable of voids
     */
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func mapToVoidDriver() -> Driver<Void> {
        return mapToVoid().asDriver(onErrorDriveWith: .empty())
    }

}

// MARK: Subscribe Finished

public extension ObservableType {
    
    /**
     Subscribes a termination handler to an observable sequence.
     
     - parameter onDisposed: Action to invoke upon gracefull or errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeFinished(onFinished: @escaping () -> Void) -> Disposable {
        return subscribe { event in
            switch event {
            case .error, .completed: onFinished()
            default: break
            }
        }
    }
}

// MARK: Subscribe Weakly

public extension ObservableType {
    
    /**
     Weakly subscribes an element handler to an observable sequence.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeNextWeakly<T: AnyObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) -> Disposable {
        return subscribe(onNext: Weakly(object, onNext))
    }
    
    func subscribeNextWeakly2<T: AnyObject, U, U1>(_ object: T, _ onNext: @escaping (T) -> (U, U1) -> Void) -> Disposable where Self.Element == (U,U1) {
        return subscribe(onNext: Weakly2(object, onNext))
    }
    
    func subscribeNextWeakly3<T: AnyObject, U, U1, U2>(_ object: T, _ onNext: @escaping (T) -> (U, U1, U2) -> Void) -> Disposable where Self.Element == (U,U1, U2) {
        return subscribe(onNext: Weakly3(object, onNext))
    }

    /**
     Weakly subscribes an element handler to an observable sequence and adds it's subscription object to `object.rx.disposeBag`.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the observable sequence.
     */
    func subscribeNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return subscribeNextWeakly(object, onNext).disposed(by: disposeBag)
    }
    
    func subscribeNext2<T: NSObject, U, U1>(_ object: T, _ onNext: @escaping (T) -> (U, U1) -> Void) where Self.Element == (U, U1) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return subscribeNextWeakly2(object, onNext).disposed(by: disposeBag)
    }
    
    func subscribeNext3<T: NSObject, U, U1, U2>(_ object: T, _ onNext: @escaping (T) -> (U, U1, U2) -> Void) where Self.Element == (U, U1, U2) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return subscribeNextWeakly3(object, onNext).disposed(by: disposeBag)
    }
}

public extension ObservableType where Element == Void {
    
    func subscribeNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> () -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return subscribe(onNext: Weakly(object, onNext)).disposed(by: disposeBag)
    }
}

public extension Observable {
    func asSignalOrEmpty() -> Signal<Element> {
        return asSignal(onErrorSignalWith: .empty())
    }
}

public extension ObservableType {
    func asSignalOrEmpty() -> Signal<Self.Element> {
        return self.asSignal(onErrorSignalWith: .empty())
    }
    func asDriverOrEmpty() -> Driver<Self.Element> {
        return self.asDriver(onErrorDriveWith: .empty())
    }
}
