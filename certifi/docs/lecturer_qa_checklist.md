# Checklist họp trao đổi với Giảng viên

| Nhóm nghiệp vụ | Điểm mơ hồ cần làm rõ với Giảng viên | Phương án mặc định đề xuất (nếu giảng viên giao tự quyết) |
| :--- | :--- | :--- |
| **Phân quyền (RBAC)** | Hệ thống có mấy vai trò (`Admin`, `Manager`, `Employee`)? Vai trò `Employee` có được xem bảng `User List` hoặc bấm `Bulk Delete` không? | `Admin`: toàn quyền; `Manager`: CRUD Student & Certificate, chỉ xem User; `Employee`: chỉ xem Student & Certificate, ẩn nút Bulk Delete. |
| **Xóa dữ liệu & Toàn vẹn** | Khi xóa một `Student` (đặc biệt qua Bulk Delete), các `Certificate` của sinh viên đó bị xóa theo (Cascade Delete), xóa mềm (`isDeleted = true`), hay chặn xóa? | Dùng **Soft Delete** (`archivedAt`) cho Student và tự động gắn cờ lưu trữ cho Certificate liên quan để giữ lịch sử tra cứu. |
| **Thang điểm GPA & Chứng chỉ** | GPA dùng thang `4.00` hay thang `10.00`? Chứng chỉ có ngày hết hạn (`expiredAt`) và điểm số (`score`) bắt buộc hay tùy chọn? | GPA thang `4.00` (hiển thị đúng 2 chữ số thập phân bằng `JetBrains Mono tabular-nums`); `expiredAt` cho phép `null` (vô thời hạn). |
| **Tài khoản & Khởi tạo User** | Khi Admin tạo mới `User` trên app, có dùng Firebase Admin SDK / Cloud Function để không bị đăng xuất phiên Admin hiện tại, hay dùng Secondary `FirebaseApp`? | Dùng Secondary `FirebaseApp` phía client (nếu không triển khai Cloud Functions) để tạo Auth user mà không mất phiên Admin. |
| **Import / Export & Tìm kiếm** | Có yêu cầu Import/Export CSV/Excel cho Student & Certificate không? Tìm kiếm cần Full-text hay chỉ lọc theo Mã SV, Họ tên, Email? | Hỗ trợ Export CSV từ danh sách đang chọn (Bulk Action); tìm kiếm chuẩn hóa chữ thường theo Mã SV, Họ tên, Email. |
