//
//  ChartDetailCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 12/5/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DetailChartCell: UITableViewCell, DetailCell, ReusableView {

    struct Constants {
        static let chartHeigth: CGFloat = 100
        static let cellSpaicing: CGFloat = 4
    }

    internal var chartTopColor: UIColor = Theme.Pallete.softGray
    internal var chartBottomColor: UIColor = Theme.Pallete.softRed
    internal var anotationsSteps: Int = 4

    private let chartHeader = ChartHeader()
    private let pageControl = UIPageControl()
    private let loader = LoadingView(animation: AppConstants.Animations.genericLoader)

    private let anotationsStackView = UIStackView.with(
        axis: .horizontal,
        distribution: .equalCentering,
        alignment: .center
    )

    private lazy var collectionLayoutView: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayoutView)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: ChartTimeBarCell.self)
        return collection
    }()

    private var maxValue: Int = 0
    private var chartDetals: WeekChartModel? {
        didSet {
            if chartDetals == nil {
                loader.show(hiddingView: contentView)
            } else {
                loader.dismiss(hiddingView: contentView)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        selectionStyle = .none
        accessibilityTraits = .notEnabled

        pageControl.pageIndicatorTintColor = Theme.Pallete.ligthGray
        pageControl.currentPageIndicatorTintColor = Theme.Pallete.softRed

        anotationsStackView.backgroundColor = Theme.Pallete.white

        loader.configure()
    }

    private func configureLayout() {
        contentView.addSubViews([chartHeader, collectionView, pageControl, anotationsStackView])
        addSubview(loader)

        chartHeader.anchor(top: contentView.topAnchor)
        chartHeader.fillHorizontal()
        chartHeader.anchorSize(height: 40)

        collectionView.anchor(top: chartHeader.bottomAnchor)
        collectionView.fillHorizontal()
        collectionView.anchorSize(height: Constants.chartHeigth)

        pageControl.anchor(top: collectionView.bottomAnchor)
        pageControl.fillHorizontal()
        pageControl.anchorSize(height: 20)

        anotationsStackView.anchor(top: pageControl.bottomAnchor, bottom: contentView.bottomAnchor, bottomConstant: Theme.Offset.small)
        anotationsStackView.fillHorizontal(offset: Theme.Offset.large)

        loader.anchor(top: contentView.topAnchor)
        loader.fillHorizontal()
        loader.anchor(bottom: contentView.bottomAnchor)
    }

    func configure(with item: DetailItem) {
        switch item {
        case .waitTime(let waitTimes, let maxValue):
            chartDetals = waitTimes
            self.maxValue = maxValue
            addAnotations()
            collectionView.reloadData()
        default: break
        }
    }

    private func addAnotations() {
        guard maxValue > 0 else { return }
        anotationsStackView.removeAllArrangedViews()
        let increase = maxValue / anotationsSteps
        var counter = increase
        for _ in Array(1...anotationsSteps) {
            let porcentaje = CGFloat(counter) / CGFloat(maxValue)
            let model = ChartAnotationModel(title: "\(counter) min", // LOCALIZE
                color: UIColor.getGradientColor(from: chartBottomColor, to: chartTopColor, percentage: porcentaje))
            let anotation = ChartAnotation(model: model)
            anotationsStackView.addArrangedSubview(anotation)
            counter += increase
        }
        layoutSubviews()
    }
}

extension DetailChartCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let chartDetals = chartDetals else { return 0 }
        pageControl.numberOfPages = chartDetals.keys.count
        return chartDetals.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionKey = WeekDays.init(rawValue: section) ?? .sunday
        return chartDetals?[sectionKey]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionKey = WeekDays.init(rawValue: indexPath.section) ?? .sunday
        guard let cell = collectionView.dequeueReusable(cell: ChartTimeBarCell.self, for: indexPath),
            let section = chartDetals?[sectionKey] else { return UICollectionViewCell() }

        let items = section[indexPath.row]
        let shouldDisplaytime = !indexPath.row.isMultiple(of: 2)

        cell.configure(withModel: items,
                       shouldDisplaytime: shouldDisplaytime,
                       topColor: chartTopColor,
                       bottomColor: chartBottomColor)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ChartBar.Constants.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpaicing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionKey = WeekDays.init(rawValue: section) ?? .sunday
        let items = chartDetals?[sectionKey] ?? []
        let cellsSpace = ChartBar.Constants.width * CGFloat(items.count)
        let cellsSpacing = Constants.cellSpaicing * CGFloat(items.count - 1)
        let emptySpace = bounds.width - cellsSpace - cellsSpacing
        return UIEdgeInsets.with(vertical: 0, horizoltal: emptySpace/2)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = WeekDays.init(rawValue: indexPath.section) ?? .sunday
        chartHeader.configure(title: section.title)
        pageControl.currentPage = indexPath.section
    }
}
