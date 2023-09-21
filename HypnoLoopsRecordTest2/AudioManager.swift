
import Foundation
import SwiftUI
import AVFoundation

class AudioManager: NSObject, ObservableObject {
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    @Published var recordings: [URL] = []
    @Published var isRecording = false
    @Published var isPlaying = false
    
    @Published var currentlyPlayingURL: URL?

    override init() {
           super.init()
           loadExistingRecordings()
       }
    
    func startRecording() {
        // Generate the recording name based on the current date and time
           let recordingName = generateRecordingName()
           let audioFilename = getDocumentsDirectory().appendingPathComponent(recordingName)
           
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            isRecording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    private func generateRecordingName() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy_HH-mm-ss"
        
        let formattedDate = formatter.string(from: date)
        return "HL_\(formattedDate).m4a"
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        
        if let url = audioRecorder?.url {
            addAndSortRecording(url: url)
        }

    }
    
    func addAndSortRecording(url: URL) {
        recordings.append(url)
        sortRecordings()
    }

    private func sortRecordings() {
        recordings.sort { (url1, url2) -> Bool in
            let date1 = (try? url1.resourceValues(forKeys: [.creationDateKey]))?.creationDate
            let date2 = (try? url2.resourceValues(forKeys: [.creationDateKey]))?.creationDate
            return date1 ?? Date() > date2 ?? Date()
        }
    }

    
    func startPlaying(audioURL: URL) {
        print("Started playing audio")
        

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            isPlaying = true
        } catch {
            print("Could not start playing")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
        print("Stoped audio")
    }
    
    func playRecording(url: URL) {
        do {
            if isPlaying {
                audioPlayer?.stop()
                isPlaying = false
                currentlyPlayingURL = nil
                return
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            currentlyPlayingURL = url
            
            audioPlayer?.delegate = self
        } catch {
            print("Failed to play recording: \(error)")
            isPlaying = false
            currentlyPlayingURL = nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func renameRecording(from oldURL: URL, to newName: String) -> Bool {
        let directory = getDocumentsDirectory()
        let newURL = directory.appendingPathComponent(newName).appendingPathExtension("m4a")
        
        do {
            try FileManager.default.moveItem(at: oldURL, to: newURL)
            
            if let index = recordings.firstIndex(of: oldURL) {
                recordings[index] = newURL
            }
            
            return true
        } catch {
            print("Renaming failed: \(error)")
            return false
        }
    }
    
    private func loadExistingRecordings() {
        let directory = getDocumentsDirectory()
        
        //Had to use creation date to maintain order in list and last song recorded ready to play.
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.creationDateKey], options: [])
            recordings = urls.filter { $0.pathExtension == "m4a" }.sorted { (url1, url2) -> Bool in
                let date1 = (try? url1.resourceValues(forKeys: [.creationDateKey]))?.creationDate
                let date2 = (try? url2.resourceValues(forKeys: [.creationDateKey]))?.creationDate
                return date1 ?? Date() > date2 ?? Date() // Note the change from '<' to '>' to reverse order
            }
        } catch {
            print("Failed to fetch recordings: \(error)")
        }
    }

}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Delegate finishedPlaying audio")
        isPlaying = false
        currentlyPlayingURL = nil
        
    }

}


