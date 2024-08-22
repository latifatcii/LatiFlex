//
//  MainViewController.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import LatiFlex
import UIKit

class MainViewController: UIViewController  {

    var viewModel: MainViewModelProtocol = MainViewModel() 
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
   
   
    @IBAction func tappedForRequest(_ sender: Any) {
        LatiFlex.shared.show()
        viewModel.tappedForRequest()
    }
    
    @IBAction func tappedForBreakingNews(_ sender: Any) {
        LatiFlex.shared.show()
        viewModel.tappedForBreakingNews()
    }
    
}

extension MainViewController: MainViewModelDelegate {
    
}
