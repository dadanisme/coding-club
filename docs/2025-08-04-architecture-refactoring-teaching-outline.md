# Architecture Refactoring Teaching Outline

## Course Overview

This hands-on workshop teaches iOS architecture patterns and SOLID principles through refactoring the existing lightsaber app. Students will transform their working but architecturally naive code into clean, maintainable, and testable architecture.

**Target Audience:** Swift developers with basic networking knowledge  
**Duration:** 2 hours (intensive refactoring session)  
**Prerequisites:** Completed Session 1 (networking fundamentals), basic SwiftUI knowledge

---

## Learning Objectives

By the end of this workshop, students will understand:

- SOLID principles and their practical application
- MVVM architecture pattern in SwiftUI
- VIPER architecture fundamentals
- How to identify and fix architectural code smells
- Why clean architecture improves AI code assistance
- Practical refactoring techniques

---

## Module 1: Code Review & Architectural Smells (20 minutes)

### 1.1 Current Architecture Analysis (10 minutes)

**Activity**: Students examine their existing `LightsaberService.swift` and identify problems:

```swift
// Current problematic code
@MainActor
class LightsaberService: ObservableObject {
    @Published var lightsabers: [Lightsaber] = []
    @Published var errorMessage: String?
    @Published var isFetchingLightsabers = false
    // ... 4 different loading states
    
    func fetchLightsabers() { /* networking + state management */ }
    func createLightsaber() { /* networking + business logic */ }
}
```

**Discussion Points**:
- What responsibilities does `LightsaberService` have?
- What happens when we need offline storage?
- How would we unit test this code?
- What if we need different UI states for the same data?

### 1.2 Identifying Architectural Smells (10 minutes)

**Code Smell Checklist** (students use this on their code):

✅ **God Object**: Does one class handle too many responsibilities?  
✅ **Tight Coupling**: Do views directly depend on concrete classes?  
✅ **Mixed Concerns**: Is business logic scattered across multiple layers?  
✅ **Hard to Test**: Can you easily unit test individual components?  
✅ **Poor AI Assistance**: Does AI struggle to understand your code structure?

**Real Example from Their Code**:
```swift
// In LightsaberDetailView.swift - Business logic in View!
private func toggleLightsaberStatus() {
    // 30 lines of business logic mixed with UI code
    let updatedLightsaber = Lightsaber(id: lightsaber.id, ...)
    service.updateLightsaber(updatedLightsaber) { success in
        // More business logic here
    }
}
```

**Key Takeaway**: "If explaining your code to AI takes multiple paragraphs, your architecture needs work."

---

## Module 2: SOLID Principles with Real Examples (30 minutes)

### 2.1 Single Responsibility Principle (8 minutes)

**Problem in Current Code**:
```swift
// LightsaberService violates SRP - does 4 different jobs:
class LightsaberService {
    // 1. Network requests
    // 2. State management  
    // 3. Error handling
    // 4. Data transformation
}
```

**Solution - Separate Responsibilities**:
```swift
// 1. Pure networking
protocol NetworkService {
    func fetch<T: Codable>(_ endpoint: String) async throws -> T
}

// 2. Business logic
class LightsaberRepository {
    private let networkService: NetworkService
    
    func fetchLightsabers() async throws -> [Lightsaber] {
        let response: APIResponse<[Lightsaber]> = try await networkService.fetch("/lightsabers")
        return response.data
    }
}

// 3. UI state management
class LightsaberListViewModel: ObservableObject {
    @Published var lightsabers: [Lightsaber] = []
    @Published var isLoading = false
    
    private let repository: LightsaberRepository
}
```

### 2.2 Open/Closed Principle (5 minutes)

**Current Problem**: Adding new lightsaber colors requires modifying `ColorUtils`:

```swift
// Violates OCP - must modify existing code for new colors
static func colorForLightsaber(_ color: String) -> Color {
    switch color.lowercased() {
    case "blue": return .blue
    case "green": return .green
    // What if we need custom colors?
    }
}
```

**Solution - Protocol-based Design**:
```swift
protocol LightsaberColorProvider {
    func color(for colorName: String) -> Color
}

struct StandardColorProvider: LightsaberColorProvider { /* standard colors */ }
struct CustomColorProvider: LightsaberColorProvider { /* custom colors */ }

// Now adding new color schemes doesn't modify existing code
```

### 2.3 Liskov Substitution, Interface Segregation & Dependency Inversion (17 minutes)

**Quick Examples with Current Code**:

**LSP**: Any `NetworkService` implementation should work in `LightsaberRepository`
**ISP**: Don't force views to depend on methods they don't use
**DIP**: Views depend on abstractions (`LightsaberViewModelProtocol`), not concrete classes

**Hands-on Exercise**: Students refactor one SOLID violation from their code.

---

## Module 3: MVVM Refactoring (40 minutes)

### 3.1 MVVM Theory (10 minutes)

**MVVM in SwiftUI Context**:
- **Model**: `Lightsaber`, business entities
- **View**: SwiftUI views (presentation only)
- **ViewModel**: `ObservableObject` classes (presentation logic + state)

**Key Rules**:
1. Views never directly access Model
2. ViewModels never import SwiftUI
3. Models have no UI dependencies

### 3.2 Practical Refactoring: LightsaberListView (15 minutes)

**Before** (current problematic code):
```swift
struct LightsaberListView: View {
    @StateObject private var service = LightsaberService() // Direct dependency!
    
    var body: some View {
        // View contains business logic
        .onDelete(perform: deleteLightsabers)
    }
    
    private func deleteLightsabers(offsets: IndexSet) {
        // Business logic in View - violation!
        for index in offsets {
            let lightsaber = service.lightsabers[index]
            service.deleteLightsaber(id: lightsaber.id) { success in
                print("Success") // What's this doing here?
            }
        }
    }
}
```

**After** (clean MVVM):
```swift
// ViewModel - handles presentation logic
class LightsaberListViewModel: ObservableObject {
    @Published var lightsabers: [Lightsaber] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: LightsaberRepositoryProtocol
    
    init(repository: LightsaberRepositoryProtocol) {
        self.repository = repository
    }
    
    @MainActor
    func loadLightsabers() async {
        isLoading = true
        do {
            lightsabers = try await repository.fetchLightsabers()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func deleteLightsaber(at offsets: IndexSet) async {
        // Proper business logic handling
        for index in offsets {
            let lightsaber = lightsabers[index]
            do {
                try await repository.deleteLightsaber(id: lightsaber.id)
                await loadLightsabers() // Refresh data
            } catch {
                errorMessage = "Failed to delete lightsaber"
            }
        }
    }
}

// View - pure presentation
struct LightsaberListView: View {
    @StateObject private var viewModel: LightsaberListViewModel
    
    init(viewModel: LightsaberListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.lightsabers) { lightsaber in
                LightsaberRowView(lightsaber: lightsaber)
            }
            .onDelete { offsets in
                Task { await viewModel.deleteLightsaber(at: offsets) }
            }
        }
        .task {
            await viewModel.loadLightsabers()
        }
    }
}
```

### 3.3 Hands-On Exercise (15 minutes)

Students refactor `AddLightsaberView` to MVVM pattern:
- Create `AddLightsaberViewModel`
- Move form validation logic to ViewModel
- Remove direct service dependencies from View

**Template Provided**:
```swift
class AddLightsaberViewModel: ObservableObject {
    @Published var name = ""
    @Published var creator = ""
    @Published var selectedColor = "blue"
    // ... other properties
    
    var isFormValid: Bool {
        // Validation logic here
    }
    
    func saveLightsaber() async throws {
        // Business logic here
    }
}
```

---

## Module 4: VIPER Architecture Introduction (20 minutes)

### 4.1 VIPER Components (8 minutes)

**VIPER = View + Interactor + Presenter + Entity + Router**

Using `LightsaberDetailView` as example:

```swift
// Entity (same as Model in MVVM)
struct Lightsaber { /* existing code */ }

// View Protocol
protocol LightsaberDetailViewProtocol: AnyObject {
    func showLightsaber(_ lightsaber: Lightsaber)
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
}

// Interactor - Business Logic
protocol LightsaberDetailInteractorProtocol {
    func loadLightsaber(id: String)
    func toggleLightsaberStatus()
}

class LightsaberDetailInteractor: LightsaberDetailInteractorProtocol {
    weak var presenter: LightsaberDetailPresenterProtocol?
    var repository: LightsaberRepositoryProtocol
    
    func toggleLightsaberStatus() {
        // Pure business logic - no UI concerns
    }
}

// Presenter - Presentation Logic
protocol LightsaberDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapToggleButton()
}

class LightsaberDetailPresenter: LightsaberDetailPresenterProtocol {
    weak var view: LightsaberDetailViewProtocol?
    var interactor: LightsaberDetailInteractorProtocol
    var router: LightsaberDetailRouterProtocol
    
    func didTapToggleButton() {
        view?.showLoading(true)
        interactor.toggleLightsaberStatus()
    }
}

// Router - Navigation Logic
protocol LightsaberDetailRouterProtocol {
    func navigateToEditLightsaber()
}
```

### 4.2 VIPER vs MVVM Comparison (7 minutes)

**When to Use Each**:

| Scenario | MVVM | VIPER |
|----------|------|-------|
| Small to medium apps | ✅ Preferred | ❌ Overkill |
| Complex business logic | ⚠️ Can work | ✅ Excellent |
| Team size > 5 developers | ⚠️ Can get messy | ✅ Clear boundaries |
| Heavy testing requirements | ✅ Good | ✅ Excellent |
| Simple CRUD operations | ✅ Perfect | ❌ Too complex |

### 4.3 Quick VIPER Demo (5 minutes)

**Live Coding**: Convert the toggle functionality from `LightsaberDetailView` to VIPER pattern.

**Focus**: Show how VIPER enforces separation of concerns more strictly than MVVM.

---

## Module 5: Architecture's Impact on AI Performance (10 minutes)

### 5.1 Why Clean Architecture Helps AI (5 minutes)

**Demonstration**: Show AI prompt results with current vs refactored code.

**Before** (messy architecture):
```
Prompt: "Add validation to lightsaber creation"
AI Response: "I need to understand your current validation logic first. Can you show me where validation happens? I see some logic in the view, some in the service..."
```

**After** (clean MVVM):
```
Prompt: "Add validation to lightsaber creation"  
AI Response: "I can see your AddLightsaberViewModel handles form logic. I'll add validation to the isFormValid computed property..."
```

### 5.2 AI-Friendly Code Patterns (5 minutes)

**Best Practices for AI Assistance**:

1. **Clear file organization**: One responsibility per file
2. **Descriptive naming**: `LightsaberRepository` vs `LightsaberService`
3. **Protocol-driven design**: AI understands interfaces easily
4. **Consistent patterns**: Same architecture across features
5. **Single source of truth**: Clear data flow

**Example**:
```swift
// AI-friendly structure
protocol LightsaberRepositoryProtocol {
    func fetchLightsabers() async throws -> [Lightsaber]
    func createLightsaber(_ lightsaber: Lightsaber) async throws -> Lightsaber
}

class LightsaberRepository: LightsaberRepositoryProtocol {
    // Implementation here - AI instantly understands purpose
}
```

**Key Insight**: "Good architecture is like clear documentation - it helps both humans and AI understand your code instantly."

---

## Module 6: Practical Refactoring Session (15 minutes)

### 6.1 Choose Your Adventure (5 minutes)

Students pick one refactoring task:

**Option A: MVVM Refactoring**
- Convert `EditLightsaberView` to MVVM
- Create `EditLightsaberViewModel`
- Move business logic out of view

**Option B: SOLID Principle Fix**
- Extract protocol from `LightsaberService`
- Create concrete implementations
- Add dependency injection

**Option C: Advanced - VIPER Module**
- Convert `LightsaberListView` to full VIPER
- Create all VIPER components
- Implement proper navigation

### 6.2 Implementation Time (10 minutes)

Students work on their chosen refactoring with instructor support.

**Success Criteria**:
- Compiles without errors
- Maintains existing functionality
- Demonstrates architectural improvement
- Easier to understand and test

---

## Assessment & Practice Activities

### Code Quality Checklist

Students evaluate their refactored code:

- [ ] **Single Responsibility**: Each class has one clear purpose
- [ ] **Testability**: Can unit test business logic independently
- [ ] **Dependency Injection**: Views/ViewModels receive dependencies
- [ ] **Clear Data Flow**: Easy to trace how data moves through app
- [ ] **AI Readability**: AI can quickly understand code structure

### Architecture Review Session

**Group Discussion**:
- Students present their refactoring choices
- Compare different approaches to same problem
- Discuss trade-offs between MVVM vs VIPER
- Share "before and after" AI prompting experiences

---

## Resources & Next Steps

### Immediate Actions
1. **Apply one SOLID principle** to your current projects
2. **Try AI coding assistance** with refactored vs original code
3. **Practice MVVM** in a simple feature

### Advanced Learning Paths
- **SwiftUI Architecture Patterns** (TCA, Redux)
- **Dependency Injection Frameworks** (Swinject)
- **Testing Architecture** (Mock objects, test doubles)
- **Modular Architecture** (Swift Package Manager)

### Recommended Reading
- Clean Architecture by Robert Martin
- iOS App Architecture by objc.io
- SwiftUI Architecture Patterns documentation

---

## Teaching Tips

### For Instructors

**Interactive Elements**:
- Live refactoring demonstrations
- "Spot the code smell" exercises
- Architecture pattern comparison tables
- Real-time AI prompting demos

**Common Student Struggles**:
- Over-engineering simple features
- Forgetting to maintain existing functionality
- Creating too many protocols/abstractions
- Missing the practical benefits of clean architecture

**Engagement Strategies**:
- Use their actual lightsaber code as examples
- Show immediate benefits (testability, AI assistance)
- Compare with popular apps they know
- Emphasize career relevance

**Assessment Methods**:
- Code review presentations
- Before/after architecture comparisons
- AI prompting demonstrations
- Peer feedback on refactored code

This workshop transforms students from "make it work" to "make it right" - essential for professional iOS development.