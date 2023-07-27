import SwiftUI
import PDFKit

struct PDFShowView: View {
    @State private var isPickedPresented = false
    @State private var documentURL: URL? = URL(string: "https://storage.googleapis.com/auen-6d3a0.appspot.com/pdf/output.pdf")
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Button {
                isPickedPresented.toggle()
            } label: {
                Text("Select your PDF")
            }
            .sheet(isPresented: $isPickedPresented) {
                if documentURL != nil {
                    PDFComponent(url: documentURL) {
                        // Download button action
                        if let url = documentURL {
                            // Perform the download action here
                            print("Downloading PDF from URL: \(url)")

                            // Call the function to handle the download completion
                            handleDownloadCompletion()
                        }
                    }
                } else {
                    PDFPicker(url: $documentURL)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("File Downloaded"), message: Text("The PDF file has been downloaded."), dismissButton: .default(Text("OK")))
        }
    }

    private func handleDownloadCompletion() {
        showAlert = true // Show the alert when the file is downloaded
    }
}

struct ShowPDFButton: View {
    var body: some View {
        HStack{
            Spacer()
            HStack{
                Spacer()
                Group{
                    Image(systemName: "doc.on.doc")
                    Text("notes")
                        .padding(.trailing)
                } .foregroundColor(.customPurple )
                
            }
        }
    }
}

struct PDFShowView_Previews: PreviewProvider {
    static var previews: some View {
        PDFShowView()
    }
}
