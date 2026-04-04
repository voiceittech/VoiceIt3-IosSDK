import UIKit
import AVFoundation

/// Entry point for enrollment flow — requests permissions and routes to the correct enrollment VC
@objc(VIEnrollSetupViewController)
class VIEnrollSetupViewController: UIViewController {

    @IBOutlet weak var enrollmentSetupTitleLabel: UILabel!
    @IBOutlet weak var enrollmentSetupSubtitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var progressView: UIView! // SpinningView

    private var myNavController: VIMainNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        myNavController = navigationController as? VIMainNavigationController

        continueButton.layer.cornerRadius = 10.0
        continueButton.backgroundColor = Theme.mainUIColor
        continueButton.setTitle(VoiceItResponseManager.getMessage("CONTINUE"), for: .normal)

        let cancelButton = UIBarButtonItem(
            title: VoiceItResponseManager.getMessage("CANCEL"),
            style: .plain,
            target: self,
            action: #selector(cancelClicked)
        )
        cancelButton.tintColor = UIColor(hexString: "#FFFFFF")
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.hidesBackButton = true

        let typeName: String
        switch myNavController?.enrollmentType {
        case .face:
            typeName = "FACE"
        case .video:
            typeName = "VOICE_FACE"
        default:
            typeName = "VOICE"
        }

        enrollmentSetupTitleLabel.text = VoiceItResponseManager.getMessage("\(typeName)_SETUP")
        enrollmentSetupSubtitleLabel.text = VoiceItResponseManager.getMessage("\(typeName)_SETUP_SUBTITLE")
        title = VoiceItResponseManager.getMessage("\(typeName)_SETUP")
    }

    @IBAction func continueClicked(_ sender: Any) {
        requestPermissions { [weak self] granted in
            guard let self, granted else { return }
            DispatchQueue.main.async {
                self.navigateToEnrollment()
            }
        }
    }

    @objc private func cancelClicked() {
        myNavController?.dismiss(animated: true) { [weak self] in
            self?.myNavController?.userEnrollmentsCancelled?()
        }
    }

    private func navigateToEnrollment() {
        let storyboard = VoiceItUtilities.getVoiceItStoryBoard()
        let vcId: String

        switch myNavController?.enrollmentType {
        case .voice:
            vcId = "voiceEnrollVC"
        case .face:
            vcId = "faceEnrollVC"
        case .video:
            vcId = "videoEnrollVC"
        default:
            vcId = "voiceEnrollVC"
        }

        let vc = storyboard.instantiateViewController(withIdentifier: vcId)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func requestPermissions(completion: @escaping (Bool) -> Void) {
        let enrollType = myNavController?.enrollmentType ?? .voice

        // Voice only needs microphone
        if enrollType == .voice {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                completion(granted)
            }
            return
        }

        // Face/Video needs camera (and video needs mic too)
        AVCaptureDevice.requestAccess(for: .video) { cameraGranted in
            guard cameraGranted else {
                completion(false)
                return
            }

            if enrollType == .video {
                AVAudioSession.sharedInstance().requestRecordPermission { micGranted in
                    completion(micGranted)
                }
            } else {
                completion(true)
            }
        }
    }
}
