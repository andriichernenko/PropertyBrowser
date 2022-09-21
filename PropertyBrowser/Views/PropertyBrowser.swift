//
//  PropertyBrowser.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import UIKit
import Combine

class PropertyBrowser: UISplitViewController {
    typealias MakeListViewer = (PropertyListViewer.SelectItem) -> UIViewController
    typealias MakeDetailViewer = (PropertyList.Item) -> UIViewController
    typealias MakePlaceholder = () -> UIViewController
    
    let makeList: MakeListViewer
    let makeDetailViewer: MakeDetailViewer
    let makePlaceholder: MakePlaceholder
    
    let viewModel: ViewModel
    
    private var listSelectionSubscription: AnyCancellable?
    
    init(
        makeList: @escaping MakeListViewer,
        makeDetailViewer: @escaping MakeDetailViewer,
        makePlaceholder: @escaping MakePlaceholder
    ) {
        self.makeList = makeList
        self.makeDetailViewer = makeDetailViewer
        self.makePlaceholder = makePlaceholder
        self.viewModel = ViewModel()
        
        super.init(style: .doubleColumn)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        delegate = self
                
        let list = makeList(viewModel.selectedPropertyItem)
        setViewController(list, for: .primary)
        show(.primary)
        
        listSelectionSubscription = viewModel.selectedPropertyItem
            .sink(receiveValue: { [weak self] selected in
                guard let self else { return }
                
                let setSecondaryController = {
                    // wrap the new secondary view in a navigation controller so that it's not stacked on top of the existing one
                    self.setViewController(UINavigationController(rootViewController: $0), for: .secondary)
                }
                
                if let selected {
                    setSecondaryController(self.makeDetailViewer(selected))
                    self.show(.secondary)
                } else {
                    setSecondaryController(self.makePlaceholder())
                }
            })        
    }
}

extension PropertyBrowser: UISplitViewControllerDelegate {

    func splitViewController(
        _: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        viewModel.hasSelection ? .secondary : .primary
    }
}
