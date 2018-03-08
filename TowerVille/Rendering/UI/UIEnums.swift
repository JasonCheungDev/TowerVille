//
//  UIActionType.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-01.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation

// DO NOT rearrange this enum
enum UIButtonID {
    case Play
    case Help
    case Settings
    case Highscore
}

enum UIScreens {
    case IntroScreen
    case HelpScreen
    case ScoreScreen
    case GameScreen
}

enum UIActionType {
    case NOT_IMPLEMENTED
    case BuildTowerBasic
    case BuildTowerSpecial
    case BuildResourceFarm
    case BuildResourceSpecial
    case BuildCancel
    
//    case PlaySelected
//    case HelpSelected
//    case SettingsSelected
//    case HighscoreSelected 
}
