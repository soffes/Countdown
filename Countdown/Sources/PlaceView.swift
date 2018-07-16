import AppKit

final class PlaceView: NSView {

	// MARK: - Properties

	let textLabel: Label = {
		let label = Label()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.alignment = .center
		return label
	}()

	let detailTextLabel: Label = {
		let label = Label()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = NSColor(white: 1, alpha: 0.5)
		label.alignment = .center
		return label
	}()


	// MARK: - Initializers

	init() {
		super.init(frame: .zero)

		addSubview(textLabel)
		addSubview(detailTextLabel)

		NSLayoutConstraint.activate([
			textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			textLabel.topAnchor.constraint(equalTo: topAnchor),
			textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			textLabel.bottomAnchor.constraint(equalTo: detailTextLabel.topAnchor),
			detailTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			detailTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
