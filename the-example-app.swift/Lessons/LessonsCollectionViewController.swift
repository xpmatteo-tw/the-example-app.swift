
import Foundation
import UIKit

class LessonsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var course: Course?

    var services: Services

    var collectionView: UICollectionView!

    var cellFactory = CollectionViewCellFactory<LessonCollectionViewCell>()

    var onLoad: (() -> Void)?

    init(course: Course, services: Services) {
        self.course = course
        self.services = services
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController

    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerNibFor(LessonCollectionViewCell.self)

        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false

        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        // Offset collection view to make space for navigation and tab bars.
        collectionView.contentInsetAdjustmentBehavior = .never

        // Configure the bottom toolbar.
        navigationController?.toolbar.barStyle = .default
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextLessonButton = UIBarButtonItem(title: NSLocalizedString("nextLessonLabel", comment: ""), style: .plain, target: self, action: #selector(LessonsCollectionViewController.didTapNextLessonButton(_:)))
        toolbarItems = [flexibleSpace, nextLessonButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onLoad?()
    }
    
    @objc func didTapNextLessonButton(_ sender: Any) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            let newIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        }
    }


    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course?.lessons?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let lesson = course?.lessons?[indexPath.item] else {
            fatalError("TODO")
        }
        let cell = cellFactory.cell(for: lesson, in: collectionView, at: indexPath)
        return cell
    }


    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
}