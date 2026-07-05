// RecordView.swift
// Extracted from ActiveView.swift - 'Hold to Record' button

import SwiftUI

struct RecordView: View {
    @ObservedObject var whisperState: WhisperState
    
    var body: some View {
        Button(action: {}) {
            Text(whisperState.isRecording ? "Recording..." : "Hold to Record")
                .font(.custom("OdinRounded-Regular", size: 12))
                .foregroundColor(.black)
                .shadow(color: .black, radius: 0, x: 2, y: 2)
        }
        .frame(width: 80, height: 80)
        .background(Color.red)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        .disabled(!whisperState.canTranscribe)
        .scaleEffect(whisperState.isRecording ? 1.1 : 1.0)
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
