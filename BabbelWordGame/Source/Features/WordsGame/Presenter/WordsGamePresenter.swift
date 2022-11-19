//
//  WordsGamePresenter.swift
//  BabbelWordGame
//
//  Created by Yasir Romaya on 11/19/22.
//

import Foundation

class WordsGamePresenter: WordsGamePresenterProtocol {
    weak var viewController: WordsGameViewControllerProtocol?
    var router: WordsGameRouterProtocol?
    
    private let fileLoader: FileLoaderProtocol
    private let wordPeerGenerator: WordPeerGeneratorProtocol
    
    private var wordList = [WordListDataModel]()
    
    private(set) var correctAttempts = 0
    private(set) var wrongAttempts = 0
    private(set) var wordPeer: WordPeer?
    
    init(viewController: WordsGameViewControllerProtocol?,
         router: WordsGameRouterProtocol?,
         fileLoader: FileLoaderProtocol,
         wordPeerGenerator: WordPeerGeneratorProtocol) {
        self.viewController = viewController
        self.router = router
        self.fileLoader = fileLoader
        self.wordPeerGenerator = wordPeerGenerator
    }
    
    func viewDidLoad() {
        loadWordList()
    }
    
    private func loadWordList() {
        viewController?.showLoadingIndicator()
        fileLoader.loadJsonFile(withPath: "words") { [weak self] (result: Result<[WordListDataModel], FileLoaderErrors>)  in
            guard let self = self else { return }
            self.viewController?.hideLoadingIndicator()
            switch result {
            case .success(let wordList):
                self.wordList = wordList
                self.startNewRound()
            case .failure(let error):
                self.viewController?.showError(error: error)
            }
        }
    }
    
    func startNewRound() {
        var viewModel = WordsGameViewModel()
        
        viewModel.correctAttempts = "Correct attempts: \(correctAttempts)"
        viewModel.wrongAttempts = "Wrong attempts: \(wrongAttempts)"
        
        wordPeer = wordPeerGenerator.getRandomWordPeer(wordList: wordList)
        
        viewModel.primaryWord = wordPeer?.primaryWord
        viewModel.primaryWordTranslation = wordPeer?.primaryWordTranslation
        
        viewController?.updateView(wordsGameViewModel: viewModel)

    }
    
    func correctButtonAction() {
        guard let wordPeer = wordPeer else { return }
        
        if wordPeer.isCorrectTranslation ?? true {
            correctAttempts += 1
        }else{
            wrongAttempts += 1
        }
        
        startNewRound()
    }
    
    func wrongButtonAction() {
        guard let wordPeer = wordPeer else { return }
        
        if wordPeer.isCorrectTranslation ?? true {
            wrongAttempts += 1
        }else{
            correctAttempts += 1
        }
        
        startNewRound()
    }

}