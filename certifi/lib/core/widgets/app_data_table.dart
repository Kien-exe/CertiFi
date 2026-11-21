// lib/core/widgets/app_data_table.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Cấu hình từng cột của Data Table
class AppTableColumn<T> {
  final String title;
  final double width;
  final bool isNumeric;
  final String Function(T item) valueGetter;
  final Widget Function(T item)? customCellBuilder;

  const AppTableColumn({
    required this.title,
    required this.width,
    required this.valueGetter,
    this.isNumeric = false,
    this.customCellBuilder,
  });
}

/// Component bảng dữ liệu chuẩn cho Student, User, Certificate:
/// 1. Sticky Header đứng yên khi cuộn dọc, đồng bộ cuộn ngang.
/// 2. Text Truncation (`...`) kèm Tooltip khi hover/nhấn giữ.
/// 3. Bulk Actions Checkbox ở cột đầu tiên.
/// 4. Cột `isNumeric = true` tự động ép kiểu `JetBrains Mono` + `tabular-nums`.
class AppDataTable<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) idGetter;
  final List<AppTableColumn<T>> columns;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final ValueChanged<T>? onRowTap;
  final List<Widget> Function(Set<String> selectedIds)? bulkActionsBuilder;

  const AppDataTable({
    super.key,
    required this.items,
    required this.idGetter,
    required this.columns,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.onRowTap,
    this.bulkActionsBuilder,
  });

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  final ScrollController _headerHorizontalCtrl = ScrollController();
  final ScrollController _bodyHorizontalCtrl = ScrollController();
  final ScrollController _bodyVerticalCtrl = ScrollController();
  bool _isSyncingScroll = false;

  @override
  void initState() {
    super.initState();
    _headerHorizontalCtrl.addListener(_syncFromHeader);
    _bodyHorizontalCtrl.addListener(_syncFromBody);
  }

  void _syncFromHeader() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_bodyHorizontalCtrl.hasClients) {
      _bodyHorizontalCtrl.jumpTo(_headerHorizontalCtrl.offset);
    }
    _isSyncingScroll = false;
  }

  void _syncFromBody() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_headerHorizontalCtrl.hasClients) {
      _headerHorizontalCtrl.jumpTo(_bodyHorizontalCtrl.offset);
    }
    _isSyncingScroll = false;
  }

  @override
  void dispose() {
    _headerHorizontalCtrl.removeListener(_syncFromHeader);
    _bodyHorizontalCtrl.removeListener(_syncFromBody);
    _headerHorizontalCtrl.dispose();
    _bodyHorizontalCtrl.dispose();
    _bodyVerticalCtrl.dispose();
    super.dispose();
  }

  double get _totalColumnsWidth =>
      AppSpacing.checkboxColumnWidth +
      widget.columns.fold(0.0, (sum, col) => sum + col.width);

  bool? get _masterCheckboxState {
    if (widget.items.isEmpty) return false;
    final allIds = widget.items.map(widget.idGetter).toSet();
    final matchedCount = widget.selectedIds.intersection(allIds).length;
    if (matchedCount == 0) return false;
    if (matchedCount == allIds.length) return true;
    return null; // Tristate khi chọn một phần
  }

  void _toggleSelectAll(bool? value) {
    final allIds = widget.items.map(widget.idGetter).toSet();
    if (_masterCheckboxState == true) {
      final updated = Set<String>.from(widget.selectedIds)..removeAll(allIds);
      widget.onSelectionChanged(updated);
    } else {
      final updated = Set<String>.from(widget.selectedIds)..addAll(allIds);
      widget.onSelectionChanged(updated);
    }
  }

  void _toggleRow(String id) {
    final updated = Set<String>.from(widget.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    widget.onSelectionChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    // Khóa giới hạn phóng to chữ của hệ điều hành ở mức tối đa 1.1x để giữ bố cục cột
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, _totalColumnsWidth);

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thanh công cụ Bulk Actions trượt xuống trong 200ms khi có dòng được chọn
                AnimatedSwitcher(
                  duration: AppDurations.medium,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: widget.selectedIds.isNotEmpty
                      ? Container(
                          key: const ValueKey('bulk_bar'),
                          height: AppSpacing.tableHeaderHeight,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            border: Border(
                              bottom: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Đã chọn ',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                '${widget.selectedIds.length}',
                                style: AppTypography.monoBody.copyWith(
                                  color: AppColors.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                ' mục',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.onPrimaryContainer,
                                ),
                              ),
                              const Spacer(),
                              if (widget.bulkActionsBuilder != null)
                                ...widget.bulkActionsBuilder!(
                                  widget.selectedIds,
                                ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // 1. STICKY HEADER: Luôn đứng yên trên đỉnh khi cuộn dọc
                SingleChildScrollView(
                  controller: _headerHorizontalCtrl,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    width: tableWidth,
                    height: AppSpacing.tableHeaderHeight,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceVariant,
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppSpacing.checkboxColumnWidth,
                          child: Center(
                            child: Checkbox(
                              tristate: true,
                              value: _masterCheckboxState,
                              onChanged: _toggleSelectAll,
                            ),
                          ),
                        ),
                        ...widget.columns.map(
                          (col) => Container(
                            width: col.width,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            alignment: col.isNumeric
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Tooltip(
                              message: col.title,
                              child: Text(
                                col.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.smallMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BODY: Cuộn dọc độc lập, đồng bộ cuộn ngang với Sticky Header
                Expanded(
                  child: Scrollbar(
                    controller: _bodyVerticalCtrl,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _bodyHorizontalCtrl,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: tableWidth,
                        child: ListView.separated(
                          controller: _bodyVerticalCtrl,
                          itemCount: widget.items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final id = widget.idGetter(item);
                            final isSelected = widget.selectedIds.contains(id);

                            return _DataTableRow<T>(
                              item: item,
                              columns: widget.columns,
                              isSelected: isSelected,
                              onToggleSelect: () => _toggleRow(id),
                              onRowTap: widget.onRowTap != null
                                  ? () => widget.onRowTap!(item)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DataTableRow<T> extends StatefulWidget {
  final T item;
  final List<AppTableColumn<T>> columns;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final VoidCallback? onRowTap;

  const _DataTableRow({
    required this.item,
    required this.columns,
    required this.isSelected,
    required this.onToggleSelect,
    this.onRowTap,
  });

  @override
  State<_DataTableRow<T>> createState() => _DataTableRowState<T>();
}

class _DataTableRowState<T> extends State<_DataTableRow<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isSelected
        ? AppColors.rowSelected
        : (_isHovered ? AppColors.rowHover : AppColors.surface);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onRowTap ?? widget.onToggleSelect,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          height: AppSpacing.tableRowHeight,
          color: bgColor,
          child: Row(
            children: [
              // 3. BULK ACTIONS CHECKBOX
              SizedBox(
                width: AppSpacing.checkboxColumnWidth,
                child: Center(
                  child: Checkbox(
                    value: widget.isSelected,
                    onChanged: (_) => widget.onToggleSelect(),
                  ),
                ),
              ),
              // DATA CELLS
              ...widget.columns.map((col) {
                final textValue = col.valueGetter(widget.item);
                // Cột số bắt buộc dùng JetBrains Mono + tabular-nums
                final textStyle = col.isNumeric
                    ? AppTypography.monoBody
                    : AppTypography.body;

                return Container(
                  width: col.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  alignment: col.isNumeric
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  // 2. TEXT TRUNCATION (`...`) + HOVER TOOLTIP
                  child: Tooltip(
                    message: textValue,
                    child: col.customCellBuilder != null
                        ? col.customCellBuilder!(widget.item)
                        : Text(
                            textValue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle,
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
