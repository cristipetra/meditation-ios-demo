import UIKit

protocol HomeViewModeling: class {
    func viewDidLoad()
    func viewDidAppear()
    func viewWillDisappear()
    var greeting: ((String) -> Void)? { get set }
    var backgroundRipImage: ((UIImage?) -> Void)? { get set }
    var ripImage: ((UIImage?) -> Void)? { get set }
    var relaxationPercentage: ((String) -> Void)? { get set }
    var stress: ((String) -> Void)? { get set }
    var meditate: ((String) -> Void)? { get set }
    var focus: ((String) -> Void)? { get set }
    var presentMeditation: ((MeditationViewModeling) -> Void)? { get set }
    var dismissMeditation: (() -> Void)? { get set }
}

class HomeViewModel: HomeViewModeling {

    init(actionOperator: ActionOperating,
         tabBarOperator: TabBarOperating,
         meditationViewModelFactory: @escaping () -> MeditationViewModeling) {
        self.actionOperator = actionOperator
        self.tabBarOperator = tabBarOperator
        self.meditationViewModelFactory = meditationViewModelFactory
    }

    // MARK: - HomeViewModeling

    func viewDidLoad() {
        greeting?("Hello Ela!")
        backgroundRipImage?(UIImage(named: "rip_background"))
        ripImage?(UIImage(named: "rip"))
        relaxationPercentage?("15%")
        stress?("89%")
        meditate?("5 min")
        focus?("25%")
    }

    func viewDidAppear() {
        actionOperator.set(mode: .singleButton(title: "COME BACK TO LIFE"))
        disposable = actionOperator.actionHandler.addHandler(
            target: self,
            handler: HomeViewModel.handleAction)
        tabBarOperator.isBarVisible = false
    }

    func viewWillDisappear() {
        disposable?.dispose()
    }

    var greeting: ((String) -> Void)?
    var backgroundRipImage: ((UIImage?) -> Void)?
    var ripImage: ((UIImage?) -> Void)?
    var relaxationPercentage: ((String) -> Void)?
    var stress: ((String) -> Void)?
    var meditate: ((String) -> Void)?
    var focus: ((String) -> Void)?
    var presentMeditation: ((MeditationViewModeling) -> Void)?
    var dismissMeditation: (() -> Void)?

    // MARK: - Privates

    private let actionOperator: ActionOperating
    private let tabBarOperator: TabBarOperating
    private let meditationViewModelFactory: () -> MeditationViewModeling
    private var disposable: Disposable?
    private var meditationViewModel: MeditationViewModeling?

    private func handleAction(action: ActionViewController.Action) {
        actionOperator.set(mode: .singleButton(title: "START MEDITATION SESSION"))
        let meditationViewModel = meditationViewModelFactory()
        presentMeditation?(meditationViewModel)
        meditationViewModel.closeMeditation = { [weak self] in
            self?.dismissMeditation?()
            self?.meditationViewModel = nil
        }
    }

}
