import SwiftUI
import PDFKit
import UIKit

struct PDFShowView: View {
    @EnvironmentObject private var audioRecorder: AudioRecorderModel
    @State private var isPickedPresented = false
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Button {
                isPickedPresented.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 50)
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.5).opacity(0.12))
                    Text("Show music notes")
                        .foregroundColor(.pink)
                } .padding(.horizontal)
            }
            .sheet(isPresented: $isPickedPresented) {
                if audioRecorder.convertedPDFURL != nil {
                    PDFComponent(url: audioRecorder.convertedPDFURL) {
                        if let url = audioRecorder.convertedPDFURL {
                            print("Downloading PDF from URL: \(url)")
                            handleDownloadCompletion()
                                                    }
                    }
                } else {
                    PDFPicker(url: $audioRecorder.convertedPDFURL)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("File Downloaded"), message: Text("The PDF file has been downloaded."), dismissButton: .default(Text("OK")))
        }
    }

    private func handleDownloadCompletion() {
        showAlert = true
    }
    
}

// MARK: - UIViewControllerRepresentable
struct PDFShowViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to do anything here
    }
}


class PDFShowViewDocumentDelegate: NSObject, UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
}


struct ShowPDFButton: View {
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Spacer()
                Group {
                    Image(systemName: "doc.on.doc")
                    Text("notes")
                        .padding(.trailing)
                } .foregroundColor(.customPurple)
                
            }
        }
    }
}
