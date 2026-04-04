import UIKit

/// Navigation controller for enrollment flows
/// Holds shared state passed from VoiceItAPIThree encapsulated methods
@objc(VIMainNavigationController)
class VIMainNavigationController: UINavigationController {

    @objc enum EnrollmentType: Int {
        case face = 0
        case video = 1
        case voice = 2
    }

    @objc var myVoiceIt: NSObject?
    @objc var uniqueId: String = ""
    @objc var contentLanguage: String = ""
    @objc var voicePrintPhrase: String = ""
    @objc var enrollmentType: EnrollmentType = .voice
    @objc var userEnrollmentsCancelled: (() -> Void)?
    @objc var userEnrollmentsPassed: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = Theme.mainUIColor
        navigationBar.backgroundColor = Theme.mainUIColor
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
}
