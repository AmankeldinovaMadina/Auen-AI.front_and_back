import SwiftUI
import AVKit

struct AudioPreviewModel: Hashable {
    var magnitude: Float
    var color: Color
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

protocol ServiceProtocol {
    func buffer(url: URL, samplesCount: Int, completion: @escaping ([AudioPreviewModel]) -> ())
}

class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func buffer(url: URL, samplesCount: Int, completion: @escaping ([AudioPreviewModel]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                var cur_url = url
                if url.absoluteString.hasPrefix("https://") {
                    let data = try Data(contentsOf: url)
                    let directory = FileManager.default.temporaryDirectory
                    let fileName = "chunk.m4a"
                    cur_url = directory.appendingPathComponent(fileName)
                    try data.write(to: cur_url)
                }
                
                let file = try AVAudioFile(forReading: cur_url)
                if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                              sampleRate: file.fileFormat.sampleRate,
                                              channels: file.fileFormat.channelCount, interleaved: false),
                   let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)) {
                    try file.read(into: buf)
                    guard let floatChannelData = buf.floatChannelData else { return }
                    let frameLength = Int(buf.frameLength)
                    let samples = Array(UnsafeBufferPointer(start:floatChannelData[0], count:frameLength))
                    var result = [AudioPreviewModel]()
                    let chunked = samples.chunked(into: samples.count / samplesCount)
                    for row in chunked {
                        var accumulator: Float = 0
                        let newRow = row.map{ $0 * $0 }
                        accumulator = newRow.reduce(0, +)
                        let power: Float = accumulator / Float(row.count)
                        let decibels = 10 * log10f(power)
                        result.append(AudioPreviewModel(magnitude: decibels, color: .gray))
                    }
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            } catch {
                print("Audio Error: \(error)")
            }
        }
    }
}

class AudioPlayViewModel: ObservableObject {
    private var timer: Timer?
    
    @Published var isPlaying: Bool = false
    @Published public var soundSamples = [AudioPreviewModel]()
    let sample_count: Int
    var index = 0
    let url: URL
    
    var dataManager: ServiceProtocol
    
    @Published var player: AVPlayer!
    @Published var session: AVAudioSession!
    
    init(url: URL, sampels_count: Int, dataManager: ServiceProtocol = Service.shared) {
        self.url = url
        self.sample_count = sampels_count
        self.dataManager = dataManager
        visualizeAudio()
        
        do {
            session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord)
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print(error.localizedDescription)
        }
        
        player = AVPlayer(url: self.url)
    }

    func startTimer() {
        count_duration { duration in
            let time_interval = duration / Double(self.sample_count)
            self.timer = Timer.scheduledTimer(withTimeInterval: time_interval, repeats: true, block: { (timer) in
                if self.index < self.soundSamples.count {
                    withAnimation(Animation.linear) {
                        self.soundSamples[self.index].color = Color(red: 0.91, green: 0.11, blue: 0.45) // Change the color to pink
                    }
                    self.index += 1
                }
            })
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.player.pause()
        self.player.seek(to: .zero)
        self.timer?.invalidate()
        self.isPlaying = false
        self.index = 0
        self.soundSamples = self.soundSamples.map { tmp -> AudioPreviewModel in
            var cur = tmp
            cur.color = Color.gray
            return cur
        }
    }
    
    func playAudio() {
        if isPlaying {
            pauseAudio()
        } else {
            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            isPlaying.toggle()
            player.play()
            startTimer()
            count_duration { _ in }
        }
    }
    
    func pauseAudio() {
        player.pause()
        timer?.invalidate()
        self.isPlaying = false
    }
    
    func count_duration(completion: @escaping(Float64) -> ()) {
        DispatchQueue.global(qos: .background).async {
            if let duration = self.player.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                DispatchQueue.main.async {
                    completion(seconds)
                }
                return
            }
            DispatchQueue.main.async {
                completion(1)
            }
        }
    }
    
    func visualizeAudio() {
        dataManager.buffer(url: url, samplesCount: sample_count) { results in
            self.soundSamples = results
        }
    }
    
    func removeAudio() {
        do {
            try FileManager.default.removeItem(at: url)
            NotificationCenter.default.post(name: Notification.Name("hide_audio_preview"), object: nil)
        } catch {
            print(error)
        }
    }
}
