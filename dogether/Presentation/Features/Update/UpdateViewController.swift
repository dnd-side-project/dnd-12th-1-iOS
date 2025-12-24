//
//  UpdateViewController.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

final class UpdateViewController: BaseViewController {
    private let updatePage = UpdatePage()
    
    override func viewDidLoad() {
        updatePage.delegate = self
        
        pages = [updatePage]
        
        super.viewDidLoad()
    }
}

// MARK: - delegate
protocol UpdateDelegate {
    func updateAction()
}

extension UpdateViewController: UpdateDelegate {
    func updateAction() {
        SystemManager().openAppStore()
    }
}
