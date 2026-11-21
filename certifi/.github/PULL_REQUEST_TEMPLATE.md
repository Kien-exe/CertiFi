## Tóm tắt thay đổi
- Feature / Scope:

## Checklist Definition of Done (Bắt buộc)
- [ ] **Kiến trúc**: UI chỉ gọi `abstract class Repository` qua Riverpod, không import Firebase SDK trong `presentation/`.
- [ ] **Model**: Toàn bộ entity/DTO dùng `freezed` + `json_serializable` và đã chạy `build_runner`.
- [ ] **Data Table**: Đủ Sticky Header, Text Truncation (`...` + Tooltip), Bulk Actions Checkbox.
- [ ] **Typography**: `Inter` cho text, `JetBrains Mono` + `tabular-nums` cho mọi cột số (GPA, tuổi, mã SV, điểm, ngày).
- [ ] **Micro-interactions**: Animation 150ms–250ms, nút scale 0.95/Ripple, Shake 150ms khi lỗi form, Toast tự ẩn sau 3s.
- [ ] **4 Trạng thái DoD**:
  - [ ] Loading State dùng Skeleton (cấm dùng Spinner).
  - [ ] Empty State có icon minh họa và nút CTA.
  - [ ] Error State báo lỗi mạng/DB kèm nút "Thử lại".
  - [ ] Happy Path hiển thị đúng dữ liệu chuẩn.
