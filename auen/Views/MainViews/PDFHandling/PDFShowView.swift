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
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 50)
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.5).opacity(0.12))
                    Text("Show music notes")
                        .foregroundColor(.pink)
                } .padding(.horizontal)
            }
            .sheet(isPresented: $isPickedPresented) {
                if documentURL != nil {
                    PDFComponent(url: documentURL) {
                        if let url = documentURL {
                            print("Downloading PDF from URL: \(url)")
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
        showAlert = true 
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
