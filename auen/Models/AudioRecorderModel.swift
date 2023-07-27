import Foundation
import SwiftUI
import Combine
import AVFoundation
import AVKit
import PDFKit


struct Recording {
    let fileURL: URL?
    let createdAt: Date
}

class AudioRecorderModel: NSObject, ObservableObject {
    static let shared = AudioRecorderModel()
    
    
    override init() {
        super.init()
        fetchRecording()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorderModel, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
 
    private var cancellables = Set<AnyCancellable>()
    let isFileConvertedPublisher = PassthroughSubject<Bool, Never>()
    
    @Published var recordings = [Recording]()
    @Published var isFileConverted = false 
    @Published var convertedFileURL: URL?
    @Published var convertedPDFURL: URL?

    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        self.isFileConverted = false
        print(isFileConverted)
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YY 'at' HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())
        
        let audioFilename = documentPath.appendingPathComponent("\(timestamp).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
       
        let fileURL = audioRecorder.url
        let mimeType = "audio/x-m4a"
        
        guard let url = URL(string: "http://127.0.0.1:8000/convert") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let formDataBody = createFormDataBody(fileURL: fileURL, mimeType: mimeType, boundary: boundary)
        request.httpBody = formDataBody
        
        print(isFileConverted)
        
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                print("File converted successfully")
               self.isFileConverted = true
    
                isFileConvertedPublisher.send(true)
                print("isFileConvertedPublisher sent: true")

                print(isFileConverted)
                self.fetchRecording()
                if let location = httpResponse.allHeaderFields["Location"] as? String {
                    self.downloadFile(at: URL(string: location)!)
                }
            } else {
                print("Error: \(statusCode)")
            }
        }
        task.resume()
        objectWillChange.send(self)
    }
    

    func downloadFile(at url: URL) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                if let data = data {
                    print("File downloaded successfully")
                    // self.handleConversionResponse(data: data) // Handle the response
                   
                    print(self.isFileConverted)
                }
            } else {
                print("Error: \(statusCode)")
            }
        }
        task.resume()
    }
    
    func createFormDataBody(fileURL: URL, mimeType: String, boundary: String) -> Data {
        var body = Data()
        
        let filename = fileURL.lastPathComponent
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"request\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        
        do {
            let fileData = try Data(contentsOf: fileURL)
            body.append(fileData)
        } catch {
            print("Failed to read file data: \(error)")
        }
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    func fetchRecording() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audioURL in directoryContents {
            let recording = Recording(fileURL: audioURL, createdAt: getFileDate(for: audioURL))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            print(url)
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecording()
    }
}

func getFileDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
       let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}
