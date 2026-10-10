import SwiftUI

struct ContentView: View {
    @State private var selectedTool: String = "Move"
    @State private var zoomLevel: Double = 100.0
    @State private var layerOpacity: Double = 100.0
    
    let tools = [
        ("Move", "arrow.up.and.down.and.left.and.right"),
        ("Marquee", "square.dashed"),
        ("Lasso", "lasso"),
        ("Magic Wand", "wand.and.stars"),
        ("Brush", "paintbrush.fill"),
        ("Eraser", "eraser.fill"),
        ("Clone Stamp", "stamp.fill"),
        ("Gradient", "rectangle.fill.on.rectangle.fill"),
        ("Type", "textformat"),
        ("Zoom", "magnifyingglass")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Options Bar (Photoshop / PhotoCraft Style)
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "paintpalette.fill")
                        .foregroundColor(.accentColor)
                    Text(selectedTool)
                        .font(.system(size: 13, weight: .semibold))
                }
                Divider().frame(height: 16)
                Text("Mode: Normal")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Opacity: \(Int(layerOpacity))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(\><MidCraft Studio Pro Mode>)
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(nsColor: .windowBackgroundColor))
            
            Divider()

            // MARK: - Main Three-Column Workspace
            NavigationSplitView {
                // Left: 34-Tool Palette Sidebar
                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(tools, id: \.0) { tool in
                            Button(action: { selectedTool = tool.0 }) {
                                Image(systemName: tool.1)
                                    .font(.system(size: 15))
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(selectedTool == tool.0 ? .white : .gray)
                                    .background(selectedTool == tool.0 ? Color.accentColor : Color.clear)
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.plain)
                            .help(tool.0)
                        }
                    }
                    .padding(6)
                }
                .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
                .navigationSplitViewColumnWidth(min: 48, ideal: 52, max: 60)
            } content: {
                // Center: Canvas Workspace
                ZStack {
                    Color(nsColor: .underPageBackgroundColor)
                        .ignoresSafeArea()
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(nsColor: .textBackgroundColor))
                            .frame(width: 700, height: 450)
                            .shadow(color: Color.black.opacity(0.4), radius: 15, x: 0, y: 8)
                            .overlay(
                                VStack(spacing: 10) {
                                    Image(systemName: "photo.artframe")
                                        .font(.system(size: 48))
                                        .foregroundColor(.secondary)
                                    Text("MidCraft Canvas Workspace")
                                        .font(.headline)
                                    Text("Ready for AI generation & Layer editing")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            )
                    }
                    
                    // Floating Status / Zoom Bar
                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            Text("Zoom: \(Int(zoomLevel))%")
                                .font(.caption)
                            Slider(value: $zoomLevel, in: 25...400, step: 25)
                                .frame(width: 100)
                            Divider().frame(height: 12)
                            Text("8-bit RGB")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .padding(.bottom, 12)
                    }
                }
                .navigationTitle("MidCraft")
            } detail: {
                // Right: Layers & AI Inspector Panels (PhotoCraft Style)
                VStack(spacing: 0) {
                    AIStudioPanelView()
                    
                    Divider()
                    
                    // Layers Stack Panel
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Layers")
                                .font(.headline)
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "plus")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        List {
                            HStack {
                                Image(systemName: "photo")
                                Text("Background Image")
                                Spacer()
                                Image(systemName: "eye")
                            }
                            HStack {
                                Image(systemName: "sparkles")
                                Text("AI Generation Layer")
                                Spacer()
                                Image(systemName: "eye")
                            }
                        }
                        .listStyle(.sidebar)
                    }
                    .frame(height: 200)
                }
                .navigationSplitViewColumnWidth(min: 280, ideal: 320, max: 380)
            }
        }
        .preferredColorScheme(.dark)
    }
}
