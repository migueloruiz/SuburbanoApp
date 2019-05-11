//
//  ChartDetailCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 12/5/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct ChartModel {
    let chartSections: [String]
    let chartData: [[ChartBarModel]]
    let maxValue: Int
    let anotations: [String]
}

enum ChartStatus {
    case loading
    case empty
    case content(chartData: ChartModel)
}

class DetailChartCell: UITableViewCell, DetailCell, ReusableView {

    struct Constants {
        static let chartHeigth: CGFloat = 100
        static let cellSpaicing: CGFloat = 4
    }

    internal var chartTopColor: UIColor = Theme.Pallete.softGray
    internal var chartBottomColor: UIColor = Theme.Pallete.softRed

    private let chartHeader = ChartHeader()
    private let pageControl = UIPageControl()
    private let loader = LoadingView(animation: AppConstants.Animations.genericLoader)
    private let emptyStateLabel = UIFactory.createLable(withTheme: UIThemes.Label.PopupBody)

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
    private var chartStatus: ChartStatus = .loading {
        didSet {
            switch chartStatus {
            case .loading:
                setLoading()
            case .empty:
                setEmptystate()
            case .content(let chartData):
                configure(chart: chartData)
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

        emptyStateLabel.text = "No hay informacion disponible" // Localize
    }

    private func configureLayout() {
        contentView.addSubViews([chartHeader, collectionView, pageControl, anotationsStackView])
        addSubview(loader)

        chartHeader.anchor(top: contentView.topAnchor)
        chartHeader.fillHorizontal()
        chartHeader.anchorSize(height: Theme.Offset.extralarge)

        collectionView.anchor(top: chartHeader.bottomAnchor)
        collectionView.fillHorizontal()
        collectionView.anchorSize(height: Constants.chartHeigth)

        collectionView.backgroundView = emptyStateLabel

        pageControl.anchor(top: collectionView.bottomAnchor)
        pageControl.fillHorizontal()
        pageControl.anchorSize(height: Theme.Offset.large)

        anotationsStackView.anchor(top: pageControl.bottomAnchor, bottom: contentView.bottomAnchor, bottomConstant: Theme.Offset.small)
        anotationsStackView.fillHorizontal(offset: Theme.Offset.large)

        loader.anchorCenterSuperview()
        loader.anchorSquare(size: Theme.Size.chartLoader)
    }

    func configure(with item: DetailItem) {
        switch item {
        case .chart( let status):
            chartStatus = status
        default: break
        }
    }

    private func setLoading() {
        loader.show(hiddingView: contentView)
    }

    private func setEmptystate() {
        emptyStateLabel.isHidden = false
        loader.dismiss(hiddingView: contentView)
    }

    private func configure(chart: ChartModel) {
        emptyStateLabel.isHidden = true
        loader.dismiss(hiddingView: contentView)
        maxValue = chart.maxValue
        add(anotations: chart.anotations)
        collectionView.reloadData()
    }

    private func add(anotations: [String]) {
        guard maxValue > 0 else { return }
        anotationsStackView.removeAllArrangedViews()
        let increase = maxValue / anotations.count
        var counter = increase
        for text in anotations {
            let porcentaje = CGFloat(counter) / CGFloat(maxValue)
            let model = ChartAnotationModel(
                title: text,
                color: UIColor.getGradientColor(from: chartBottomColor, to: chartTopColor, percentage: porcentaje)
            )
            let anotation = ChartAnotation(model: model)
            anotationsStackView.addArrangedSubview(anotation)
            counter += increase
        }
        layoutSubviews()
    }
}

extension DetailChartCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch chartStatus {
        case .loading, .empty:
            return 0
        case .content(let chartData):
            return chartData.chartSections.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch chartStatus {
        case .loading, .empty:
            return 0
        case .content(let chartData):
            return chartData.chartData[section].count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch chartStatus {
        case .loading, .empty:
            return UICollectionViewCell()
        case .content(let chart):
            guard let cell = collectionView.dequeueReusable(cell: ChartTimeBarCell.self, for: indexPath) else { return UICollectionViewCell() }

            let items = chart.chartData[indexPath.section][indexPath.row]
            let shouldDisplaytime = !indexPath.row.isMultiple(of: 2)

            cell.configure(withModel: items,
                           maxValue: maxValue,
                           shouldDisplaytime: shouldDisplaytime,
                           topColor: chartTopColor,
                           bottomColor: chartBottomColor)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ChartBar.Constants.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpaicing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch chartStatus {
        case .loading, .empty:
            return UIEdgeInsets.zero
        case .content(let chart):
            let items = chart.chartData[section].count
            let cellsSpace = ChartBar.Constants.width * CGFloat(items)
            let cellsSpacing = Constants.cellSpaicing * CGFloat(items - 1)
            let emptySpace = bounds.width - cellsSpace - cellsSpacing
            return UIEdgeInsets.with(vertical: 0, horizoltal: emptySpace/2)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = WeekDays.init(rawValue: indexPath.section) ?? .sunday
        chartHeader.configure(title: section.title)
        pageControl.currentPage = indexPath.section
    }
}
