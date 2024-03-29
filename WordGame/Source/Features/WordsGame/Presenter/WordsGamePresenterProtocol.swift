//
//  WordsGamePresenterProtocol.swift
//  WordGame
//
//  Created by Yasir Romaya on 11/19/22.
//

import Foundation

protocol WordsGamePresenterProtocol: AnyObject {
    var viewController: WordsGameViewControllerProtocol? { get set }
    var router: WordsGameRouterProtocol? { get set }
    
    var roundTimer: Int { get }
    var roundTimerLimit: Int { get }
    var roundsLimit: Int { get }
    var correctAttempts: Int { get }
    var wrongAttempts: Int { get }
    var wordPeer: WordPeer? { get }
    
    func viewDidLoad()
    
    func startNewRound()
    func correctButtonAction()
    func wrongButtonAction()
    
    func restart()
}
