import UIKit

/// Completion screen shown after successful enrollment
@objc(VIEnrollFinishViewController)
class VIEnrollFinishViewController: UIViewController {

    @IBOutlet weak var enrollmentSetupTitleLabel: UILabel!
    @IBOutlet weak var enrollmentSetupSubtitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    private var myNavController: VIMainNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        myNavController = navigationController as? VIMainNavigationController

        doneButton.layer.cornerRadius = 10.0
        doneButton.backgroundColor = Theme.mainUIColor
        doneButton.setTitle(VoiceItResponseManager.getMessage("DONE"), for: .normal)

        let typeName: String
        switch myNavController?.enrollmentType {
        case .face:
            typeName = "FACE"
        case .video:
            typeName = "VOICE_FACE"
        default:
            typeName = "VOICE"
        }

        enrollmentSetupTitleLabel.text = VoiceItResponseManager.getMessage("\(typeName)_READY")
        enrollmentSetupSubtitleLabel.text = VoiceItResponseManager.getMessage("\(typeName)_READY_SUBTITLE")
    }

    @IBAction func doneClicked(_ sender: Any) {
        myNavController?.dismiss(animated: true) { [weak self] in
            self?.myNavController?.userEnrollmentsPassed?("")
        }
    }
}
