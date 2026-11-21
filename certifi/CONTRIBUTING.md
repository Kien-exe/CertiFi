# Quy ước Git Workflow (Dev A & Dev B)

## 1. Cấu trúc nhánh (Branching Strategy)
- `main`: Nhánh production ổn định, chỉ merge từ `develop` qua Pull Request (bắt buộc pass CI).
- `develop`: Nhánh tích hợp chung giữa A và B.
- Nhánh tính năng: `feat/<owner>/<feature>-<short-desc>`
  - Ví dụ Dev A (UI): `feat/a/certificates-table-ui`
  - Ví dụ Dev B (Data): `feat/b/certificates-firestore-repo`
- Nhánh sửa lỗi: `fix/<owner>/<issue-desc>`
- Nhánh thay đổi hợp đồng Domain: `chore/contract-<entity>` (BẮT BUỘC cả A và B cùng review trước khi merge).

## 2. Quy ước Commit (Conventional Commits)
Cú pháp: `<type>(<scope>): <mô tả ngắn không quá 72 ký tự>`
- `feat(students): add bulk delete bar with 200ms slide transition`
- `fix(certificates): clamp tabular-nums column width on narrow viewports`
- `refactor(domain): standardize AppFailure union across repositories`
- `chore(ci): enforce dart analyze and freezed verification on PR`

## 3. Quy tắc chống xung đột Codegen (`*.freezed.dart`, `*.g.dart`)
- KHÔNG sửa tay file `*.freezed.dart` và `*.g.dart`.
- Luôn chốt và merge nhánh `chore/contract-*` vào `develop` trước khi A và B tách nhánh feature song song.
- Chạy lệnh sau trước khi push:
  `dart run build_runner build --delete-conflicting-outputs && dart analyze`
