//
//  CompletedView.swift
//  VocaList
//
//  Created by rishabh b on 6/12/25.
//

import SwiftUI
import SwiftData

struct CompletedView: View {
    
    // MARK: - VARIABLES
    @Environment(\.modelContext) private var context
    @State private var showSettings = false
    
    @Query(
        filter: #Predicate<Item> { $0.isCompleted == true },
        sort: [SortDescriptor(\Item.completedAt, order: .reverse)]
    ) private var completedItemsList: [Item]
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                List {
                    Group {
                        AppHeaderView {
                            HStack(spacing: 12) {
                                if !completedItemsList.isEmpty {
                                    SummaryView(count: completedItemsList.count, itemType: "completed", iconName: "checkmark.circle.fill")
                                }

                                Button {
                                    showSettings = true
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(.purple)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Settings")
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.appListRowBackground)
                    }
                    
                    if completedItemsList.isEmpty {
                        ContentUnavailableView {
                            Label("No Completed Items", systemImage: "checklist")
                        } description: {
                            Text("Complete some items to see them here!")
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.appListRowBackground)
                    } else {
                        ForEach(completedItemsList) { item in
                            CompletedItemView(item: item)
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        }
                        .onDelete(perform: deleteItem)
                    }
                }
                .background(Color.clear)
                .padding(.top, -40)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // MARK: - FUNCTIONS
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(completedItemsList[index])
            }
            
            // Save Changes
            try? context.save()
        }
    }
}
