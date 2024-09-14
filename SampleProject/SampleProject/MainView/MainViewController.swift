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
        LatiFlex.shared.appendEventTypes(type: "Firebase")
        LatiFlex.shared.appendEventTypes(type: "Facebook")
        LatiFlex.shared.appendEventTypes(type: "Adjust")
        LatiFlex.shared.appendEvents(type: "Firebase", name: "Mock Event", parameters: ["mock event parameter": "Mock Event 123"])
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
