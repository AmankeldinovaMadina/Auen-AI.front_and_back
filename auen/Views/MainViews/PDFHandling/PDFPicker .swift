import UIKit
import SwiftUI

struct PDFPicker: UIViewControllerRepresentable {
    @Binding var url: URL?

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("SwiftUI updated")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
extension PDFPicker {
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: PDFPicker

        init(parent: PDFPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.url = url
            }
        }
    }
}
