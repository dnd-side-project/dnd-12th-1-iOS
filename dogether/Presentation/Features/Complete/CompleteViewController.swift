//
//  CompleteViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit

final class CompleteViewController: BaseViewController {
    private let completePage = CompletePage()
    private let viewModel = CompleteViewModel()
    
    override func viewDidLoad() {
        completePage.delegate = self
        pages = [completePage]
        super.viewDidLoad()
    }
    
    override func setViewDatas() {
         if let datas = datas as? CompleteViewDatas {
             viewModel.completeViewDatas.accept(datas)
         }
         
         bind(viewModel.completeViewDatas)
     }
}

protocol CompleteDelegate: AnyObject {
    func goHomeAction()
    func shareJoinCodeAction()
}

extension CompleteViewController: CompleteDelegate {
    func goHomeAction() {
        coordinator?.setNavigationController(MainViewController())
    }
    
    func shareJoinCodeAction() {
        let data = viewModel.completeViewDatas.value
        
        let invite = SystemManager.inviteGroup(
            groupName: data.groupInfo.name,
            joinCode: data.joinCode
        )
        present(UIActivityViewController(activityItems: invite, applicationActivities: nil), animated: true)
    }
}
