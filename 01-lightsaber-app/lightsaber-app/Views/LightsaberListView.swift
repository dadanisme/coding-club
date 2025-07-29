//
//  LightsaberListView.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct LightsaberListView: View {
    @StateObject private var service = LightsaberService()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if service.isFetchingLightsabers {
                    ProgressView("Loading lightsabers...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(service.lightsabers) { lightsaber in
                            NavigationLink(destination: LightsaberDetailView(lightsaber: lightsaber)) {
                                LightsaberRowView(lightsaber: lightsaber)
                            }
                        }
                        .onDelete(perform: deleteLightsabers)
                    }
                    .refreshable {
                        service.fetchLightsabers()
                    }
                }
            }
            .navigationTitle("Lightsabers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddLightsaberView()
            }
            .alert("Error", isPresented: .constant(service.errorMessage != nil)) {
                Button("OK") {
                    service.errorMessage = nil
                }
            } message: {
                Text(service.errorMessage ?? "")
            }
        }
        .onAppear {
            service.fetchLightsabers()
        }
        .environmentObject(service)
    }
    
    private func deleteLightsabers(offsets: IndexSet) {
        for index in offsets {
            let lightsaber = service.lightsabers[index]
            service.deleteLightsaber(id: lightsaber.id) { success in
                print("Success")
            }
        }
    }
}

struct LightsaberRowView: View {
    let lightsaber: Lightsaber
    
    var body: some View {
        HStack {
            Circle()
                .fill(colorForLightsaber(lightsaber.color))
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lightsaber.name)
                    .font(.headline)
                
                Text("Created by \(lightsaber.creator)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(lightsaber.displayColor)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(colorForLightsaber(lightsaber.color).opacity(0.2))
                        .cornerRadius(8)
                    
                    if !lightsaber.isActive {
                        Text("Inactive")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func colorForLightsaber(_ color: String) -> Color {
        ColorUtils.colorForLightsaber(color)
    }
}

#Preview {
    LightsaberListView()
}
