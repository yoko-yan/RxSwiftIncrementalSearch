import UIKit
import WikipediaAPI
import Library

class FirstTableViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

// MARK: - Public
extension FirstTableViewCell {
    func configure(_ searchData: WikipediaSearch) {
        guard let data = searchData.snippet.data(using: .utf8) else {
            return
        }

        titleLabel.text = searchData.title

        dateLabel.text = searchData.updateDate.string(format: "yyyy/MM/dd")
        dateLabel.font = dateLabel.font.withSize(12)
        dateLabel.textColor = UIColor.systemGray

        do {
            let option: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
            let attributedString = try NSMutableAttributedString(data: data, options: option, documentAttributes: nil)
            let font = contentLabel.font.withSize(10)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.systemGray2,
                .paragraphStyle: paragraphStyle
            ]
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
            contentLabel.attributedText = attributedString
            contentLabel.numberOfLines = 0 // 複数行の設定
            contentLabel.lineBreakMode = .byTruncatingTail
            contentLabel.sizeToFit()
        } catch {
            contentLabel.text = searchData.title
            print(error.localizedDescription)
        }
    }
}

// MARK: - Private
private extension FirstTableViewCell {

}
