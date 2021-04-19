import Foundation
import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Driver` of source `Driver`'s elements, with `nil` elements filtered out.
     */

    func filterNil() -> Driver<Element.Wrapped> {
        return self.flatMap { element -> Driver<Element.Wrapped> in
            guard let value = element.value else {
                return Driver<Element.Wrapped>.empty()
            }
            return Driver<Element.Wrapped>.just(value)
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with `valueOnNil`.
     - parameter valueOnNil: value to use when `nil` is encountered.
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by `valueOnNil`.
     */
    
    func replaceNilWith(_ valueOnNil: Element.Wrapped) -> Driver<Element.Wrapped> {
        return self.map { element -> Element.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with result returned by `handler`.
     - parameter handler: `nil` handler function that returns `Driver` of non-`nil` elements.
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by the handler's returned non-`nil` elements.
     */
    
    func catchOnNil(_ handler: @escaping () -> Driver<Element.Wrapped>) -> Driver<Element.Wrapped> {
        return self.flatMap { element -> Driver<Element.Wrapped> in
            guard let value = element.value else {
                return handler()
            }
            return Driver<Element.Wrapped>.just(value)
        }
    }
}


public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    func mapToVoid() -> Driver<Void> {
        return map { _ in }
    }
    
    
    func take(_ count: Int) -> Driver<Self.Element> {
        return self.asObservable().take(1).asDriverOrEmpty()
    }

    /**
     Weakly drives an element handler to an drivable sequence.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the drivable sequence.
     - returns: Subscription object used to unsubscribe from the drivable sequence.
     */
    func driveNextWeakly<T: AnyObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) -> Disposable {
        return drive(onNext: Weakly(object, onNext))
    }
    
    func driveNextWeakly2<T: AnyObject, U, U1>(_ object: T, _ onNext: @escaping (T) -> (U, U1) -> Void) -> Disposable where Self.Element == (U,U1) {
        return drive(onNext: Weakly2(object, onNext))
    }
    
    func driveNextWeakly3<T: AnyObject, U, U1, U2>(_ object: T, _ onNext: @escaping (T) -> (U, U1, U2) -> Void) -> Disposable where Self.Element == (U, U1, U2) {
        return drive(onNext: Weakly3(object, onNext))
    }

    /**
     Weakly drives an element handler to an drivable sequence.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the drivable sequence.
     - returns: Subscription object used to unsubscribe from the drivable sequence.
     */
    func driveOnNextWeakly<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return drive(onNext: Weakly(object, onNext)).disposed(by: disposeBag)
    }
    /**
     Weakly invokes an action for each Next event in the drivable sequence, and propagates all driver messages through the result sequence.
     
     - parameter onNext: Action to invoke for each element in the drivable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func driveNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return driveNextWeakly(object, onNext).disposed(by: disposeBag)
    }
    
    func driveNext2<T: NSObject, U, U1>(_ object: T, _ onNext: @escaping (T) -> (U, U1) -> Void) where Self.Element == (U, U1) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return driveNextWeakly2(object, onNext).disposed(by: disposeBag)
    }
    
    func driveNext3<T: NSObject, U, U1, U2>(_ object: T, _ onNext: @escaping (T) -> (U, U1, U2) -> Void) where Self.Element == (U, U1, U2) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return driveNextWeakly3(object, onNext).disposed(by: disposeBag)
    }
    
    func driveOnNext<T>(_ subject: PublishSubject<T>) -> Disposable where Self.Element == T {
            self.drive(onNext: { object in
                subject.onNext(object)
            })
        }

    
    func mapAndDriveWeakly<Q, T: AnyObject>(query: @escaping (Self.Element) -> Q?, _ object: T, _ onNext: @escaping (T) -> (Q) -> Void) -> Disposable {
        
        return map(query)
            .filterNil()
            .driveNextWeakly(object, onNext)
    }
        
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element == Void {
    
    func driveNextWeakly<T: AnyObject>(_ object: T, _ onNext: @escaping (T) -> () -> Void) -> Disposable {
        return drive(onNext: Weakly(object, onNext))
    }
    
    func driveNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> () -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return drive(onNext: Weakly(object, onNext)).disposed(by: disposeBag)
    }
    
}


public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType, Element.Wrapped: Equatable {
    /**
     Returns an observable sequence that contains only distinct contiguous elements according to equality operator.
     
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    
    func distinctUntilChanged() -> Driver<Element> {
        return self.distinctUntilChanged { (lhs, rhs) -> Bool in
            return lhs.value == rhs.value
        }
    }
}


public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    func flatMap<R>(_ selector: @escaping (Element) throws -> Observable<R>)
        -> Observable<R> {
            return self.asObservable().flatMap(selector)
    }
}

public extension ObservableConvertibleType {
    func asSignalOrEmpty() -> Signal<Self.Element> {
        return self.asSignal(onErrorSignalWith: .empty())
    }
}
