import SwiftUI
import SwiftData

struct DebugView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor(\Item.createdAt, order: .reverse)]) private var allItems: [Item]
    
    var body: some View {
        NavigationView {
            List {
                Section("Database Info") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Items: \(allItems.count)")
                            .font(.headline)
                        
                        Text("Active Items: \(allItems.filter { !$0.isCompleted }.count)")
                        
                        Text("Completed Items: \(allItems.filter { $0.isCompleted }.count)")
                        
                        if let url = context.container.configurations.first?.url {
                            Text("Database Path:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(url.path(percentEncoded: false))
                                .font(.caption)
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    UIPasteboard.general.string = url.path(percentEncoded: false)
                                }
                        }
                    }
                }
                
                Section("All Items") {
                    ForEach(allItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .strikethrough(item.isCompleted)
                            
                            Text("Created: \(item.createdAt, style: .date)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if item.isCompleted {
                                Text("Completed: \(item.completedAt, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            
                            Text("Sort Order: \(item.sortOrder)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Database Debug")
        }
    }
}

