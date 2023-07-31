import SwiftUI
import PDFKit

struct PDFComponent: UIViewRepresentable {
    let url: URL?
    let downloadButtonAction: () -> Void

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()

        if let url = url {
            let pdfView = PDFView()
            DispatchQueue.main.async {
                pdfView.document = PDFDocument(url: url)
            }
            pdfView.autoScales = true

            let downloadButton = UIButton(type: .system)
            downloadButton.setTitle("Download PDF", for: .normal)
            downloadButton.addTarget(context.coordinator, action: #selector(Coordinator.downloadButtonTapped), for: .touchUpInside)

            containerView.addSubview(pdfView)
            containerView.addSubview(downloadButton)

            pdfView.translatesAutoresizingMaskIntoConstraints = false
            downloadButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                pdfView.topAnchor.constraint(equalTo: containerView.topAnchor),
                pdfView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                pdfView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                pdfView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

                downloadButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                downloadButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20) // Adjust bottom margin as needed
            ])
        }

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("pdf file printed")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }


    class Coordinator: NSObject {
        let parent: PDFComponent

        init(parent: PDFComponent) {
            self.parent = parent
        }

        @objc func downloadButtonTapped() {
            parent.downloadButtonAction()
        }
    }
}
