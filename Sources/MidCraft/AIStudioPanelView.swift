import SwiftUI

struct AIStudioPanelView: View {
    @State private var selectedTab: Int = 0
    @State private var promptText: String = ""
    @State private var aspectRatio: String = "16:9"
    
    @State private var creativity: Double = 5.0
    @State private var upscaleFactor: String = "4x"
    
    @State private var isLoading: Bool = false
    @State private var statusMessage: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("✨ AI Studio")
                    .font(.title3)
                    .bold()
                Spacer()
                Button(action: {}) {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.top)

            Picker("AI Mode", selection: $selectedTab) {
                Text("Midjourney").tag(0)
                Text("Magnific AI").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Divider()

            if selectedTab == 0 {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Prompt Metni")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $promptText)
                        .font(.body)
                        .frame(height: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                        )
                    
                    HStack {
                        Text("En Boy Oranı (--ar):")
                            .font(.subheadline)
                        Spacer()
                        Picker("", selection: $aspectRatio) {
                            Text("16:9").tag("16:9")
                            Text("1:1").tag("1:1")
                            Text("9:16").tag("9:16")
                        }
                        .frame(width: 90)
                    }

                    Spacer()

                    if isLoading {
                        ProgressView("Midjourney Üretiyor...")
                            .frame(maxWidth: .infinity)
                    } else {
                        Button(action: { triggerMidjourney() }) {
                            Text("Görsel Üret (Midjourney)")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.horizontal)

            } else {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Aktif Katman Detaylandırma")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Yaratıcılık (Creativity): \(Int(creativity))")
                            .font(.subheadline)
                        Slider(value: $creativity, in: 1...10, step: 1)
                        Text("Değer arttıkça Magnific yeni mikro detaylar ekler.")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Ölçeklendirme Çarpanı")
                            .font(.subheadline)
                        Picker("Scale", selection: $upscaleFactor) {
                            Text("2x").tag("2x")
                            Text("4x").tag("4x")
                            Text("8x").tag("8x")
                        }
                        .pickerStyle(.segmented)
                    }

                    Spacer()

                    if isLoading {
                        ProgressView("Magnific ile İşleniyor...")
                            .frame(maxWidth: .infinity)
                    } else {
                        Button(action: { triggerMagnific() }) {
                            Text("Magnific ile Zenginleştir")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                    }
                }
                .padding(.horizontal)
            }

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .background(Color(nsColor: .controlBackgroundColor))
    }

    private func triggerMidjourney() {
        isLoading = true
        statusMessage = "İstek Midjourney'e gönderildi..."
        Task {
            do {
                _ = try await NetworkManager.shared.generateMidjourneyImage(prompt: promptText, aspectRatio: aspectRatio)
                statusMessage = "Başarılı! Görsel tuvale aktarıldı."
                isLoading = false
            } catch {
                statusMessage = "Hata: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }

    private func triggerMagnific() {
        isLoading = true
        statusMessage = "Magnific AI motoruna bağlanılıyor..."
        Task {
            do {
                let dummyURL = URL(string: "https://example.com/sample.png")!
                _ = try await NetworkManager.shared.enhanceWithMagnific(imageURL: dummyURL, creativity: creativity, upscaleFactor: upscaleFactor)
                statusMessage = "Magnific detaylandırma tamamlandı!"
                isLoading = false
            } catch {
                statusMessage = "Hata: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
