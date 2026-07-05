// RecordButtonView.swift
// Formerly RecordView.swift

import SwiftUI

struct RecordButtonView: View {
    @ObservedObject var whisperState: WhisperState
    
    var body: some View {
        Button(action: {}) {
            ZStack {
                Image(systemName: "mic.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 80, height: 80)
        .background(Color.red.opacity(0.5))
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.black, lineWidth: 3))
        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        .disabled(!whisperState.canTranscribe)
        .scaleEffect(whisperState.isRecording ? 1.5 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: whisperState.isRecording)
        .onLongPressGesture(
            minimumDuration: 0.0,
            maximumDistance: .infinity,
            perform: {
                // This fires when the long press ends
            },
            onPressingChanged: { pressing in
                if pressing {
                    // User started pressing - start recording
                    if !whisperState.isRecording {
                        Task {
                            await whisperState.toggleRecord()
                        }
                    }
                } else {
                    // User released - stop recording
                    if whisperState.isRecording {
                        Task {
                            await whisperState.toggleRecord()
                        }
                    }
                }
            }
        )
    }
}

