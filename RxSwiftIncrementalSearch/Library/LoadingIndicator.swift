import SVProgressHUD

public enum LoadingIndicatorMaskType {
    case clear
    case black

    var progressMaskType: SVProgressHUDMaskType {
        switch self {
        case .clear:
            return .clear
        case .black:
            return .black
        }
    }
}

struct LoadingIndicator {
    static func show(_ status: String? = nil) {
        SVProgressHUD.show(withStatus: status)
    }

    static func showWithMask(_ status: String? = nil, maskType: LoadingIndicatorMaskType = .clear) {
        show(status)
        SVProgressHUD.setDefaultMaskType(maskType.progressMaskType)
    }

    static func dismiss() {
        SVProgressHUD.dismiss()
        SVProgressHUD.setDefaultMaskType(.none)
    }
}
