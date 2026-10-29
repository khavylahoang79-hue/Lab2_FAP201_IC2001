# Lab2_FAP201_IC2001
# Lab2_FAP201 - Lighting an LED with Logic Gates

## Thông tin chung
- **Môn học:** FAP201 - FPGA Programming
- **Bài thực hành:** Lab02 - Lighting an LED with Logic Gates (CLO1 & CLO2)
- **Mục tiêu:** Thiết kế, kiểm chứng và hiện thực mạch logic tổ hợp sử dụng cổng AND để điều khiển LED (chỉ sáng khi CẢ HAI nút bấm được nhấn) trên bo mạch FPGA[cite: 4, 5].

## Môi trường và Phần cứng
- **Công cụ phát triển:** Gowin EDA[cite: 4]
- **Bo mạch (Board):** Xiaomeige ACG525[cite: 4]
- **Chip FPGA (Target Device):** GW5A-LV25UG324C2/I1[cite: 4]
- **Ngôn ngữ:** VHDL (IEEE 1164 STD_LOGIC)[cite: 5]

## Nguyên lý hoạt động & Bảng chân lý
- **Mạch tổ hợp (Combinational Circuit):** 
  * Tín hiệu công tắc ngõ vào `i_sw1` và `i_sw2` được nghịch đảo để xác định trạng thái bấm (`sw1_pressed <= not i_sw1;`, `sw2_pressed <= not i_sw2;`)[cite: 5].
  * Biểu thức logic điều khiển ngõ ra `o_led <= not (sw1_pressed and sw2_pressed);` đảm bảo phép toán AND logic chỉ kích hoạt khi cả hai nút bấm cùng nhấn[cite: 5].
  * Mạch hoạt động hoàn toàn dựa trên logic tổ hợp, không dùng xung nhịp (clock), thanh ghi (register) hay máy trạng thái (FSM).
- **Phân tích cực tính phần cứng (Active-Low Hardware):**
  * **Công tắc ngõ vào (`i_sw1`, `i_sw2`):** Nút bấm Tích cực mức thấp (Active-Low)[cite: 5]. Khi thả nút mang mức logic `'1'` (nhờ cấu hình `PULL_MODE=UP`), khi nhấn nút mang mức logic `'0'`[cite: 4, 5].
  * **Đèn LED ngõ ra (`o_led`):** Đèn Tích cực mức thấp (Active-Low) — TẮT ở mức logic `'1'` và SÁNG ở mức logic `'0'`.
  * **Logic vận hành:** Đèn LED chỉ SÁNG (ngõ ra `o_led` kéo về `'0'`) khi CẢ HAI nút bấm đều được nhấn (`sw1_pressed = '1'` và `sw2_pressed = '1'`)[cite: 5]. Ngược lại, nếu thả ít nhất một nút bấm, `o_led` mang mức logic `'1'` và LED sẽ TẮT[cite: 5].

### Bảng chân lý (Truth Table)
| i_sw1 (KEY0) | i_sw2 (KEY1) | sw1_pressed | sw2_pressed | o_led (LED0) | Trạng thái vật lý |
| :---: | :---: | :---: | :---: | :---: | :--- |
| `1` (Thả) | `1` (Thả) | `0` | `0` | `1` | Thả cả 2 nút $\rightarrow$ LED TẮT[cite: 4, 5] |
| `1` (Thả) | `0` (Nhấn) | `0` | `1` | `1` | Chỉ nhấn KEY1 $\rightarrow$ LED TẮT[cite: 4, 5] |
| `0` (Nhấn) | `1` (Thả) | `1` | `0` | `1` | Chỉ nhấn KEY0 $\rightarrow$ LED TẮT[cite: 4, 5] |
| `0` (Nhấn) | `0` (Nhấn) | `1` | `1` | `0` | Nhấn CẢ HAI nút $\rightarrow$ LED SÁNG[cite: 4, 5] |

## Bảng ánh xạ chân vật lý (Physical Constraints Mapping)
Tín hiệu được cấu hình trong file `Lab02.cst`[cite: 4]:

| Tín hiệu VHDL | Chân FPGA | Linh kiện phần cứng | Cấu hình I/O (3.3V Bank VCCIO) |
| :--- | :---: | :--- | :--- |
| `i_sw1` | `B16` | Switch 1 / KEY0 | `PULL_MODE=UP`, `DRIVE=OFF`[cite: 4] |
| `i_sw2` | `A15` | Switch 2 / KEY1 | `PULL_MODE=UP`, `DRIVE=OFF`[cite: 4] |
| `o_led` | `D14` | Output LED / LED0 | `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 4] |

## Cấu trúc thư mục dự án (Project Structure)
Kho lưu trữ được tổ chức theo tiêu chuẩn đánh giá của môn học:

- `src/Lab2.vhd`: Mã nguồn VHDL mô tả mạch AND logic điều khiển LED[cite: 5].
- `constraints/Lab2.cst`: File gán chân vật lý cho chip Gowin GW5A[cite: 4].
- `sim/lab02_tb.vhd`: File Testbench kiểm thử 4 vector ngõ vào (`11`, `10`, `01`, `00`)[cite: 5].
- `waveform/`: Ảnh chụp hoặc file trace dạng sóng mô phỏng (`.ghw`).
- `reports/`: Báo cáo quá trình Tổng hợp (Synthesis) và P&R (Place & Route).
- `evidence/`: Nhật ký Programmer và bằng chứng nghiệm thu trên bo mạch phần cứng.
- `README.md`: Tài liệu hướng dẫn dự án.

## Hướng dẫn Build & Kiểm chứng (Execution & Verification)
1. **Mô phỏng (Simulation):**
   * Mở công cụ mô phỏng (GHDL / Gowin Simulator) và chạy testbench `sim/lab02_tb.vhd`.
   * Đảm bảo cả 4 trường hợp tổ hợp ngõ vào đều vượt qua các câu lệnh `assert` và hiển thị kết quả đúng trên sóng dạng waveform.
2. **Tổng hợp & Nạp phần cứng (Synthesis & Programming):**
   * Mở project trong Gowin EDA với target `GW5A-LV25UG324C2/I1`[cite: 4].
   * Chạy quá trình **Synthesis** và **Place & Route**.
   * Kết nối bo mạch Xiaomeige ACG525, sử dụng Gowin Programmer để nạp file bitstream (`.fs`) xuống chip[cite: 4].
   * Nhấn giữ đồng thời KEY0 và KEY1 để xác nhận LED0 chỉ sáng khi cả hai nút bấm cùng được tác động[cite: 4, 5].
