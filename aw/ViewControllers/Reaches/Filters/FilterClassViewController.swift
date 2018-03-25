//
//  FilterClassViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class FilterClassViewController: UIViewController {
    @IBOutlet weak var class1: UISwitch!
    @IBOutlet weak var class2: UISwitch!
    @IBOutlet weak var class3: UISwitch!
    @IBOutlet weak var class4: UISwitch!
    @IBOutlet weak var class5: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

}

extension FilterClassViewController {
    func initialize() {
        setClassSwitches()
    }
    
    func setClassSwitches() {
        let difficultyRange = DefaultsManager.classFilter
        
        class1.isOn = difficultyRange.contains(1)
        class2.isOn = difficultyRange.contains(2)
        class3.isOn = difficultyRange.contains(3)
        class4.isOn = difficultyRange.contains(4)
        class5.isOn = difficultyRange.contains(5)
    }
}

extension FilterClassViewController: FilterViewControllerType {
    func save() {
        var range: [Int] = []
        if class1.isOn { range.append(1)}
        if class2.isOn { range.append(2)}
        if class3.isOn { range.append(3)}
        if class4.isOn { range.append(4)}
        if class5.isOn { range.append(5)}
        DefaultsManager.classFilter = range
    }
}
