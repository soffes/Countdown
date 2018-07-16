import AppKit

final class Label: NSTextField {
	override init(frame: NSRect) {
		super.init(frame: frame)
		isEditable = false
		drawsBackground = false
		isBordered = false
		isBezeled = false
		isSelectable = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
