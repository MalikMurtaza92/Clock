//
//  ViewController.swift
//  Clock-Project
//
//  Created by Murtaza Mehmood on 16/07/2021.
//

import UIKit

class ViewController: UIViewController {

    let clockView: ClockView = {
        let view = ClockView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(clockView)
        clockView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        clockView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        clockView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        clockView.heightAnchor.constraint(equalToConstant: 150).isActive = true

    }


}

