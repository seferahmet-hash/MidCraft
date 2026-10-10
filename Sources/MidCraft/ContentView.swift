import SwiftUI

struct ContentView: View {
    @State private var promptText: String = ""
    @State private var selectedAspectRatio: String = "16:9"
    @State private var creativityLevel: Double = 5.0
    @State private var isProcessing: Bool = false
    
    let aspectRatios = ["1:1", "16:9", "9:16", "4:3", "3:4"]

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 16) {
                Text("MidCraft Studio")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Midjourney Prompt")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $promptText)
                        .frame(height: 100)
                        .padding(4)
                        .background(Color(.textBackgroundColor))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Aspect Ratio")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Picker("Aspect Ratio", selection: $selectedAspectRatio) {
                        ForEach(aspectRatios, id: \.self) { ratio in
                            Text(ratio).tag(ratio)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Magnific AI (mcp.magnific.com)")
                        .font(.headline)
                    
                    HStack {
                        Text("Creativity")
                        Spacer()
                        Text(String(format: "%.1f", creativityLevel))
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $creativityLevel, in: 1.0...10.0, step: 0.5)
                }
                
                Spacer()
                
                Button(action: {
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isProcessing = false
                    }
                }) {
                    HStack {
                        Spacer()
                        if isProcessing {
                            ProgressView()
                                .controlSize(.small)
                            Text("Generating...")
                        } else {
                            Image(systemName: "sparkles")
                            Text("Run AI Generation")
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(isProcessing)
            }
            .padding()
            .navigationSplitViewColumnWidth(min: 280, ideal: 320, max: 400)
        } detail: {
            ZStack {
                Color(.windowBackgroundColor)
                    .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    Image(systemName: "photo.badge.sparkles")
                        .font(.system(size: 64))
                        .foregroundColor(.gray.opacity(0.6))
                    
                    Text("No Active Canvas Layer")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("Enter a prompt on the left panel or drop an image to start transforming with Midjourney & Magnific AI.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 400)
                }
                .padding()
            }
        }
        .frame(minWidth: 900, minHeight: 600)
    }
}
