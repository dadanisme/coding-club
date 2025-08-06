import SwiftUI

struct PlanetsView: View {
    @StateObject private var viewModel = PlanetViewModel()
    
    private var isErrorPresented: Bool {
        viewModel.errorMessage != nil
    }
    
    var body: some View {
        List(viewModel.planets, id: \.name) { planet in
            NavigationLink(destination: Text("Details for \(planet.name)")) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(planet.name)
                            .font(.headline)
                        Text(planet.terrain.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(planet.climate.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
            }
        }
        .navigationTitle("Planets")
        .onAppear {
            viewModel.loadPlanets()
        }
        .alert("Error", isPresented: .constant(isErrorPresented)) {
            Button("OK", action: dismissError)
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
    
    private func dismissError() {
        viewModel.errorMessage = nil
    }
}

#Preview {
    PlanetsView()
}
