import SwiftUI

struct RecordingVisualizing: View {
    @State private var animationTrigger = false
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .frame(height: 40)
                    .foregroundColor(.clear)
                HStack(spacing: 1) {
                    ForEach(0..<15) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 4, height: .random(in: 4...35))
                            .foregroundColor(.black)
                            .animation(animationTrigger ? .easeInOut(duration: 0.25).repeatForever(autoreverses: true) : .default)
                    }
                }
            }
            
            Text("Recording")
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .semibold))
                .padding(.top, 10)
                .fixedSize()
            
            Text("make sure you are well heard")
                .foregroundColor(.black)
                .opacity(0.6)
                .font(.system(size: 16, weight: .regular))
        }
        .onAppear {
            startAnimationTimer()
        }
        .onDisappear {
            stopAnimationTimer()
        }
    }
    
    private func startAnimationTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            animationTrigger.toggle()
        }
    }
    
    private func stopAnimationTimer() {
        animationTrigger = false
    }
}
