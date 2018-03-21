//
//  UIActionType.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-01.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

enum UIScreens {
    case IntroScreen
    case HelpScreen
    case ScoreScreen
    case GameScreen
}

enum UIActionType : Int {
    case NOT_IMPLEMENTED
    
    // Game screen actions
    case BuildTowerBasic
    case BuildTowerSpecial
    case BuildResourceFarm
    case BuildResourceSpecial
    case BuildCancel
    case UpgradeStructure = 200
    case RepairStructure = 201
    case SellStructure = 202

    // Intro screen buttons
    case PlaySelected = 100
    case HelpSelected = 101
    case SettingsSelected = 102
    case HighscoreSelected = 103
    
    // Generic buttons
    case BackSelected = 900
}
