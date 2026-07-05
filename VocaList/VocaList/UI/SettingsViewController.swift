import UIKit
import SwiftUI
import SwiftData

final class SettingsViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case appearance
        case data
        case about

        var title: String {
            switch self {
            case .appearance: return "Appearance"
            case .data: return "Data"
            case .about: return "About"
            }
        }
    }

    private let modelContext: ModelContext
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var completedItemCount = 0
    private var themeSegmentedControl: UISegmentedControl?
    private let headerHostingController: UIHostingController<SettingsHeaderView>
    private var lastHeaderHeight: CGFloat = 0

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.headerHostingController = UIHostingController(rootView: SettingsHeaderView())
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureHeader()
        refreshCompletedItemCount()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCompletedItemCount()
        updateThemeSegmentSelection()
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderSizeIfNeeded()
    }

    // MARK: - Setup

    private func configureTableView() {
        view.backgroundColor = .appBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .appBackground
        tableView.separatorColor = .separator
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = -40
        tableView.contentInset.bottom = 60
        tableView.verticalScrollIndicatorInsets.bottom = 60
        tableView.sectionHeaderTopPadding = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ThemeCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ClearCell")

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureHeader() {
        headerHostingController.view.backgroundColor = .appBackground
        updateHeaderSizeIfNeeded()
    }

    private func updateHeaderSizeIfNeeded() {
        guard let headerView = headerHostingController.view else { return }
        let width = tableView.bounds.width
        guard width > 0 else { return }

        headerView.frame.size = CGSize(width: width, height: 1)
        let height = headerView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        guard height > 0, abs(lastHeaderHeight - height) > 0.5 || tableView.tableHeaderView !== headerView else { return }

        lastHeaderHeight = height
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        tableView.tableHeaderView = headerView
    }

    // MARK: - Data

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private var completedItemsCountLabel: String {
        completedItemCount == 1 ? "1 item" : "\(completedItemCount) items"
    }

    private func currentAppearanceMode() -> AppearanceMode {
        let rawValue = UserDefaults.standard.string(forKey: SettingsKeys.appearanceMode) ?? AppearanceMode.dark.rawValue
        return AppearanceMode(rawValue: rawValue) ?? .dark
    }

    private func refreshCompletedItemCount() {
        let descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.isCompleted == true })
        completedItemCount = (try? modelContext.fetchCount(descriptor)) ?? 0
    }

    private func updateThemeSegmentSelection() {
        let currentMode = currentAppearanceMode()
        if let index = AppearanceMode.allCases.firstIndex(of: currentMode) {
            themeSegmentedControl?.selectedSegmentIndex = index
        }
    }

    private func saveAppearanceMode(_ mode: AppearanceMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: SettingsKeys.appearanceMode)
        NotificationCenter.default.post(name: .appearanceModeDidChange, object: nil)
    }

    private func clearAllCompletedItems() {
        let descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.isCompleted == true })
        guard let items = try? modelContext.fetch(descriptor), !items.isEmpty else { return }

        for item in items {
            modelContext.delete(item)
        }

        do {
            try modelContext.save()
            refreshCompletedItemCount()
            tableView.reloadSections(IndexSet(integer: Section.data.rawValue), with: .automatic)
            presentSuccessAlert()
        } catch {
            print("Failed to clear completed items: \(error)")
        }
    }

    // MARK: - Alerts

    private func presentClearConfirmation() {
        let message = "This will permanently delete \(completedItemCount) completed item\(completedItemCount == 1 ? "" : "s")."
        let alert = UIAlertController(title: "Clear Completed Items?", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear All", style: .destructive) { [weak self] _ in
            self?.clearAllCompletedItems()
        })
        present(alert, animated: true)
    }

    private func presentSuccessAlert() {
        let alert = UIAlertController(
            title: "Completed Items Cleared",
            message: "All completed items have been removed.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions

    @objc private func themeSegmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        guard index >= 0, index < AppearanceMode.allCases.count else { return }
        saveAppearanceMode(AppearanceMode.allCases[index])
    }

    // MARK: - Cells

    private func themeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .appListRowBackground
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Theme"
        label.font = UIFont.preferredFont(forTextStyle: .body)

        let segmentedControl = UISegmentedControl(items: AppearanceMode.allCases.map(\.label))
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(themeSegmentChanged(_:)), for: .valueChanged)

        cell.contentView.addSubview(label)
        cell.contentView.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            segmentedControl.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            segmentedControl.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12),
        ])

        themeSegmentedControl = segmentedControl
        updateThemeSegmentSelection()
        return cell
    }

    private func clearCompletedCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClearCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "Clear Completed Items"
        content.textProperties.color = completedItemCount == 0 ? .systemRed.withAlphaComponent(0.4) : .systemRed
        content.secondaryText = completedItemsCountLabel
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
        cell.backgroundColor = .appListRowBackground
        cell.selectionStyle = completedItemCount == 0 ? .none : .default
        cell.isUserInteractionEnabled = completedItemCount > 0
        return cell
    }

    private func versionCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "Version"
        content.secondaryText = appVersion
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
        cell.backgroundColor = .appListRowBackground
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard Section(rawValue: section) == .about else { return nil }
        return "Transcription runs entirely on-device. Your voice recordings and tasks are stored locally on this device."
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .appearance:
            return themeCell(for: tableView, at: indexPath)
        case .data:
            return clearCompletedCell(for: tableView, at: indexPath)
        case .about:
            return versionCell(for: tableView, at: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard Section(rawValue: indexPath.section) == .data, completedItemCount > 0 else { return }
        presentClearConfirmation()
    }
}

private struct SettingsHeaderView: View {
    var body: some View {
        AppHeaderView()
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
    }
}
