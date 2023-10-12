
import Foundation
import SwiftUI
import AVFoundation

class AudioManager: NSObject, ObservableObject {
    
    private var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioPlayerSecond: AVAudioPlayer?
    var musicPlayer: AVAudioPlayer? //make all players private again when funcs are moved here.
    
    @Published var isPlayingMusic = false
    @Published var recordings: [URL] = []
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var isPlayingSecondAudio = false
    
    @Published var currentlyPlayingURL: URL?
    @Published var currentlyPlayingMusicURL: URL?
    @Published var delayFactor: Double = 0.14 //20 should be max speed (OuterLoop)
    @Published var delayFactor2: Double = 0.14 //(InnerLoop)
    
    @Published var musicVolume: Float = 1.0
    @Published var mainVocalsAudio: Float = 1.0
    
    @Published var musicDuration: TimeInterval = 0
    @Published var musicCurrentTime: TimeInterval = 0
    @Published var isRepeatModeOn: Bool = false
    private var musicProgressTimer: Timer?
    
//    @Published var isLooping: Bool = false
//    var audioURLToPlay: URL?
//    var musicURLToPlay: URL?
    
    var timeRemaining: TimeInterval {
            return max(musicDuration - musicCurrentTime, 0)
        }
    
    var playSecondWorkItem: DispatchWorkItem?
    var restartLoopWorkItem: DispatchWorkItem?
    var onLoopShouldRestart: (() -> Void)?


    override init() {
           super.init()
           loadExistingRecordings()
       }
    
    func startRecording() {
        // Generate the recording name based on the current date and time
           let recordingName = generateRecordingName()
           let audioFilename = getDocumentsDirectory().appendingPathComponent(recordingName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 320000
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
            print("Error playing audio: \(error.localizedDescription)")

        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
        playSecondWorkItem?.cancel()
        restartLoopWorkItem?.cancel()
        print("Stoped audio")
    }
    
    func playRecording(url: URL) {
        do {
            if isPlaying {
                audioPlayer?.stop()
                isPlaying = false
                //currentlyPlayingURL = nil
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
            //currentlyPlayingURL = nil
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
    
    //Specialized Player
    //This is the first recrding that will play
    func playRecordingSpecial(url: URL) {
        do {
            if isPlaying {
                audioPlayer?.stop()
                audioPlayerSecond?.stop()
                isPlaying = false
                //currentlyPlayingURL = nil
                isPlayingSecondAudio = false
                //audioPlayerSecond = nil
                //audioPlayer = nil
                return
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            audioPlayer?.volume = mainVocalsAudio
            currentlyPlayingURL = url
            
            isPlayingSecondAudio = false
            
            playSecondWorkItem = DispatchWorkItem {
                self.playSecondVersionOfAudio(url: url)
            }
            
            //innerloop for second play at 50% reduced volume.
            let delay = (audioPlayer?.duration ?? 0) * (1 - delayFactor2) // restart loop of firt audio
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: playSecondWorkItem!)
        
            
        } catch {
            print("Failed to play recording: \(error)")
            isPlaying = false
            //currentlyPlayingURL = nil
        }
    }

    //PLay Second version of audio at 50% volume
    func playSecondVersionOfAudio(url: URL) {
        do {
            audioPlayerSecond = try AVAudioPlayer(contentsOf: url)
            audioPlayerSecond?.delegate = self
            audioPlayerSecond?.volume = 0.5
            audioPlayerSecond?.play()
            isPlayingSecondAudio = true

            restartLoopWorkItem = DispatchWorkItem {
                    self.onLoopShouldRestart?()
                }

                //Outer loop for restart of first audio (delayFactor):
            let halfDuration = (audioPlayerSecond?.duration ?? 0) * (1.0 - delayFactor)
            print("audioPlayer1.duration", audioPlayer?.duration)
            print("audioPlayerSecond.duration", audioPlayerSecond?.duration)
            print("halfDuration", halfDuration)
                DispatchQueue.main.asyncAfter(deadline: .now() + halfDuration, execute: restartLoopWorkItem!)

            
        } catch {
            print("Failed to play second audio: \(error)")
        }
    }
    
//    func startAudio() {
//            isLooping = true
//            if isLooping {
//                startLooping()
//                if let musicURL = musicURLToPlay {
//                    startMusic(url: musicURL)
//                }
//            }
//        }
//        
//        func stopAudio() {
//            isLooping = false
//            stopMusic()
//            stopPlaying()
//            onLoopShouldRestart = nil
//            audioPlayerSecond = nil
//            audioPlayer = nil
//        }
//        
//        func startLooping() {
//            guard !recordings.isEmpty else { return }
//            let defaultLoop = recordings.first!
//            let loopAudioURL = audioURLToPlay ?? defaultLoop
//            
//            onLoopShouldRestart = { [weak self] in
//                self?.startLooping()
//            }
//            
//            playRecordingSpecial(url: loopAudioURL)
//        }


    func getDuration(of audioURL: URL) -> TimeInterval {
        do {
            let audioAsset = AVURLAsset(url: audioURL, options: nil)
            let audioDuration = CMTimeGetSeconds(audioAsset.duration)
            print("AudioDuration", audioDuration)
            return audioDuration
        } catch {
            print("Error fetching audio duration: \(error)")
            return 0.0
        }
    }

    func startMusic(url: URL) {
        guard !isPlayingMusic else { return }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            //musicPlayer?.numberOfLoops = -1  // Infinite loop
            musicPlayer?.delegate = self
            musicPlayer?.play()
            musicPlayer?.volume = musicVolume
            currentlyPlayingMusicURL = url
            isPlayingMusic = true
        } catch {
            print("Could not start music: \(error)")
        }
        musicDuration = musicPlayer?.duration ?? 0
        musicCurrentTime = musicPlayer?.currentTime ?? 0
        musicProgressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                 self?.updateMusicCurrentTime()
             }
    }

    func stopMusic() {
        musicPlayer?.stop()
        isPlayingMusic = false
        musicProgressTimer?.invalidate()
        musicProgressTimer = nil
    }
    
    //Restart DispatchQue when loop timing is toggled in settings
    func adjustDelay(_ newDelayFactor: Double) {
        // Assuming audioPlayer is currently playing
        guard let audioPlayer = audioPlayer, audioPlayer.isPlaying else { return }
        
        // Cancel the current playSecondWorkItem
        playSecondWorkItem?.cancel()
        
        // Calculate the new delay based on the current playback time and newDelayFactor
        let remainingTime = audioPlayer.duration - audioPlayer.currentTime
        let newDelay = remainingTime * newDelayFactor
        
        // Reschedule playSecondWorkItem with the new delay
        playSecondWorkItem = DispatchWorkItem {
            self.playSecondVersionOfAudio(url: self.currentlyPlayingURL!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + newDelay, execute: playSecondWorkItem!)
    }
    
    
    func adjustRestartDelay(_ newDelayFactor: Double) {
            // Check if audioPlayerSecond is currently playing
            guard let audioPlayerSecond = audioPlayerSecond, audioPlayerSecond.isPlaying else { return }
            
            // Cancel the current restartLoopWorkItem
            restartLoopWorkItem?.cancel()
            
            // Calculate the new delay based on the current playback time and newDelayFactor
            let remainingTime = audioPlayerSecond.duration - audioPlayerSecond.currentTime
            let newDelay = remainingTime * newDelayFactor
            
            // Reschedule restartLoopWorkItem with the new delay
            restartLoopWorkItem = DispatchWorkItem {
                self.onLoopShouldRestart?()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + newDelay, execute: restartLoopWorkItem!)
        }
    
    func updateMusicCurrentTime() {
          musicCurrentTime = musicPlayer?.currentTime ?? 0
      }

}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player === audioPlayer {
                   isPlaying = false
                   //currentlyPlayingURL = nil
               } else if player === audioPlayerSecond {
                   isPlayingSecondAudio = false
               } else if player === musicPlayer {
                   print("MusicPlayerAM Trigger", isPlayingMusic)
                   isPlayingMusic = false
               }

        isPlaying = false
        //currentlyPlayingURL = nil
    }
}


