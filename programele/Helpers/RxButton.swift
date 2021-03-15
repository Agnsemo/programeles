import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIButton {
    /// Reactive wrapper for `TouchUpInside` control event.
    var tapDriver: Driver<Void> {
        return tap.asDriver()
    }
   /// Reactive wrapper for `isHighlighted` control event.
    var isHighlighted: Observable<Bool> {
        let anyObservable = self.base.rx.methodInvoked(#selector(setter: self.base.isHighlighted))
        
        let boolObservable = anyObservable
            .flatMap { Observable.from(optional: $0.first as? Bool) }
            .startWith(self.base.isHighlighted)
            .distinctUntilChanged()
            .share()
        
        return boolObservable
    }
}

extension UIButton {
    var tapDriver: SharedSequence<DriverSharingStrategy, Void> {
        return rx.tap
            .asDriver()
    }
    
    func tapDriver<T: Any>(withValue value: T?) -> SharedSequence<DriverSharingStrategy, T?> {
        return rx.tap
            .asDriver()
            .map{ value }
    }
    
    func tapDriver<T: Any>(withValue value: T) -> SharedSequence<DriverSharingStrategy, T> {
        return rx.tap
            .asDriver()
            .map{ value }
    }
}

extension UIBarButtonItem {
    var tapDriver: SharedSequence<DriverSharingStrategy, Void> {
        return rx.tap
            .asDriver()
    }
    
    func tapDriver<T: Any>(withValue value: T?) -> SharedSequence<DriverSharingStrategy, T?> {
        return rx.tap
            .asDriver()
            .map{ value }
    }
    
    func tapDriver<T: Any>(withValue value: T) -> SharedSequence<DriverSharingStrategy, T> {
        return rx.tap
            .asDriver()
            .map{ value }
    }
}
