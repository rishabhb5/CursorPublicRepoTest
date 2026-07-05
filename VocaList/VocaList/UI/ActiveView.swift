// 20250612
// ActiveView

import SwiftUI
import SwiftData

struct ActiveView: View {
    // MARK: - VARIABLES
    
    // Insert, Delete, Save (CRUD operations)
    @Environment(\.modelContext) private var context
    @StateObject var whisperState = WhisperState()
    
    // var alItemList: Fetches data from the DB, updates UI reactively when data changes
    // // Querying all Items
    @Query(sort: [SortDescriptor(\Item.sortOrder),
                  SortDescriptor(\Item.createdAt, order:.reverse)]) private var allItemsList:[Item]
    
    // Filtering for only Active items (isCompleted = false)
    private var activeItemsList: [Item] {
        allItemsList.filter { !$0.isCompleted}
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                List {
                    Group {
                        AppHeaderView {
                            if !activeItemsList.isEmpty {
                                SummaryView(count: activeItemsList.count, itemType: "active", iconName: "bolt.fill")
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.appListRowBackground)
                    
                    if activeItemsList.isEmpty {
                        ContentUnavailableView {
                            Label("No Active Items", systemImage: "checklist")
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.appListRowBackground)
                        } description: {
                            Text("Click '+' to add a new item or check check Completed tab")
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.appListRowBackground)
                        }
                    } else {
                        ForEach(activeItemsList) { item in
                            ActiveItemView(item: item)
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .listRowBackground(Color.appListRowBackground)
                        }
                        .onDelete(perform: deleteItem) // Swift handles the index (no need to pass in)
                        .onMove(perform: moveItem) // Swift handles the index (no need to pass in)
                    }
                }
                //.padding(.top, -8)
                .background(Color.clear)
                .padding(.top, -40)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }   //VStack
            
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    RecordButtonView(whisperState: whisperState)
                        .padding(.trailing, 16)
                        .padding(.bottom, 80)
                }
            }
        }
        .onAppear {
            cleanupExistingItems()
        }
        .onChange(of: whisperState.isRecording) { oldValue, newValue in
            // Only save when recording stops (was true, now false)
            if oldValue == true && newValue == false {
                // Add a small delay to let transcription complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if (whisperState.recordedText != "[BLANK_AUDIO]") {
                        let trimmedText = whisperState.recordedText.trimmingCharacters(in: .whitespacesAndNewlines)
                        let newItem = Item(title: trimmedText)
                        // Set sortOrder to 0 to make it appear at the top
                        newItem.sortOrder = 0
                        // Update sortOrder for all existing items
                        for item in activeItemsList {
                            item.sortOrder += 1
                        }
                        
                        context.insert(newItem)
                        
                        do {
                            try context.save()
                            print("Saved item: \(trimmedText)")
                        } catch {
                            print("Failed to save item: \(error)")
                        }
                    }

                }
            }
        } /* onChange */
    } /* body */
    
    // MARK: - PRIVATE FUNCTIONS
    
    // Clean up existing items to remove any invisible characters
    private func cleanupExistingItems() {
        for item in allItemsList {
            let originalTitle = item.title
            let cleanedTitle = originalTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            if originalTitle != cleanedTitle {
                item.title = cleanedTitle
                print("Cleaned item title: '\(originalTitle)' -> '\(cleanedTitle)'")
            }
        }
        
        do {
            try context.save()
            print("Successfully cleaned up existing items")
        } catch {
            print("Failed to clean up existing items: \(error)")
        }
    }
    
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(activeItemsList[index])
            }
            
            // Save Changes
            try? context.save()
        }
    } /* deleteItem() */
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        var updatedItems = Array(activeItemsList)
        updatedItems.move(fromOffsets: source, toOffset: destination)
        
        // Update sort order for all items
        for (index, item) in updatedItems.enumerated() {
            item.sortOrder = index
        }
        
        // Save Changes
        do {
            try context.save()
        } catch {
            print("Failed to save reordered items: \(error)")
        }
    } /* moveItem() */
    
} /* ActiveView */
