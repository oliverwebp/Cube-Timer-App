//
//  ContentView.swift
//  firstAttempt
//
//  Created by Oliver Nguyen on 2/21/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var textColor = Color.white;
    @State var longPressed = false;
    @ObservedObject var stopwatch = Stopwatch()
    var body: some View {
        VStack {
            HStack {
                Button("Settings", action: {
                    
                })
                Spacer()
                Button("Example", action: {
                    
                })
                Spacer()
                Text("Test")
                    .onLongPressGesture(perform: {
                        print("hi")
                    })
            }
            Spacer()
            
            ZStack {
                Image("chonksoncat")
                    .resizable()
                    .ignoresSafeArea()
                switch stopwatch.stateOfWatch {
                case .stopped :
                    Image("chonksoncat")
                        .resizable()
                        .ignoresSafeArea()
                        .onLongPressGesture(
                            minimumDuration:99999,
                            perform: {
                            
                        }, onPressingChanged: {_ in
                            if self.longPressed {
                                stopwatch.start()
                                longPressed = false;
                                textColor = Color.white
                            } else if textColor == Color.white {
                                textColor = Color.red
                            } else {
                                textColor = Color.white
                            }
                        })
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.4)
                                .onEnded({_ in
                                textColor = Color.green
                                self.longPressed = true;
                            })
                        )
                case .running :
                    Button(action: {
                        stopwatch.stop()
                        textColor = Color.white
                    }, label: {
                        Image("chonksoncat")
                            .resizable()
                            .ignoresSafeArea()
                    })
                }
                Text(stopwatch.timeInString)
                    .foregroundColor(textColor).font(.system(size: 30, design: .monospaced))
            }
        }
    }
}
enum stateofWatch {
    case running
    case stopped
}

class Stopwatch:ObservableObject {
    @Published var progressTime = 0.0
    @Published var timeInString = "0.000"
    @Published var stateOfWatch:stateofWatch = .stopped
   var timer = Timer()

    func start() {
        stateOfWatch = .running
        progressTime = 0.0;
        timeInString = "0.000"
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) {_ in
            
            self.progressTime += 0.001
            self.display()
        }
    }
    var hours: Int {
       Int(progressTime) / 3600
    }

    var minutes: Int {
      (Int(progressTime) % 3600) / 60
    }

    var seconds: Int {
        Int(progressTime) % 60
    }
    var milli: Int {
        Int(abs(Double(Int(progressTime)) - progressTime)*1000)
    }
    func display() {
        
        if (hours == 0 && minutes == 0) {
            timeInString=String(seconds)
        } else if (hours == 0 && minutes != 0) {
            timeInString = String(minutes)
            timeInString+=":"
            timeInString+=String(format: "%02d", seconds)
        } else {
            timeInString = String(hours)
            timeInString+=":"
            timeInString+=String(format: "%02d", minutes)
            timeInString+=":"
            timeInString+=String(format: "%02d", seconds)
        }
        timeInString+="."
        timeInString+=String(format:"%03d",milli)
    }
        
    func stop() {
        stateOfWatch = .stopped
        timer.invalidate()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
