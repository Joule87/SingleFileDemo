//
//  ViewController.swift
//  CompassUIKitDemo
//
//  Created by Julio Collado Perez on 8/22/23.
//

import UIKit

class ViewController: UIViewController {
    private let refreshInterval = 1.0 / 60.0

    private let timeLabel = UILabel()
    private let startButton = UIButton(type: .system)
    private let pauseButton = UIButton(type: .system)

    private var startTime: Date?
    private var timer: Timer?
    private var lastElapsedTime: TimeInterval?
    private var gapTime: TimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        timeLabel.text = "00:00:00"
        timeLabel.font = .monospacedDigitSystemFont(ofSize: 72, weight: .regular)
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true

        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.addTarget(self, action: #selector(pausedTapped), for: .touchUpInside)
        pauseButton.isHidden = true

        let verticalStack = UIStackView(arrangedSubviews: [timeLabel, startButton, pauseButton])
        verticalStack.axis = .vertical
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)

        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalToConstant: 200),
            verticalStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            verticalStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        ])
    }

    @objc func startTapped(sender: UIButton) {
        startButton.isHidden = true
        pauseButton.isHidden = false

        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            var currentElapsedTime = Date().timeIntervalSince(self.startTime ?? Date())
            
            if let gapTime = self.gapTime {
                currentElapsedTime += gapTime
            }
            
            self.lastElapsedTime = currentElapsedTime
            
            let minutes = Int(currentElapsedTime / 60)
            let seconds = Int(currentElapsedTime - TimeInterval(minutes))
            let hundredths = Int(100 * (currentElapsedTime - TimeInterval(minutes) - TimeInterval(seconds)))

            self.timeLabel.text = String(format: "%02d:%02d:%02d", minutes, seconds, hundredths)
        }
    }

    @objc func pausedTapped(sender: UIButton) {
        startButton.isHidden = false
        pauseButton.isHidden = true

        if let lastElapsedTime = lastElapsedTime {
            self.gapTime = lastElapsedTime
        }
        
        timer?.invalidate()
        timer = nil
    }
}
