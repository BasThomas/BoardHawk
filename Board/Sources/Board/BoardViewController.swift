import UIKit

public class BoardViewController: UIViewController {
    let project: Project

    public init(project: Project) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = project.name
    }
}
