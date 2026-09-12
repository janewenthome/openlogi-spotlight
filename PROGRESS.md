# Progress

## 2026-09-12

- 專案初始化，目的為建立搭配 OpenLogi 使用的 macOS 簡報聚光燈 companion app。
- 已確認本機為 Apple Silicon macOS 26，並安裝 OpenLogi 0.7.4。
- 已完成架構決策：OpenLogi 負責 Logitech 按鍵 → `F13`，本專案負責原生 AppKit overlay。

## 2026-09-12 — MVP

- 完成 `OpenLogiSpotlight.app`：選單列常駐、全域 `F13` toggle、`Esc` 隱藏、多螢幕 overlay、游標跟隨與 click-through 視窗。
- `make test` 通過；release build、ad-hoc signed app bundle 與本機安裝流程通過。
- OpenLogi 已由 Homebrew 安裝；目前 CLI 尚未找到可開啟的 Logitech HID++ 裝置，需在實際滑鼠/權限環境驗證。
- 尚未建立 GitHub remote，因 `gh auth status` 顯示尚未登入 GitHub。

## 2026-09-12 — F13 按鍵整合診斷

- 已確認 OpenLogi v0.7.4 的 GUI 動作清單沒有 Custom Shortcut；不能從截圖中的選單直接設定 `⌘⇧9`。
- 已偵測到實體裝置 `LIFT For Business`，並將 `Forward (側鍵 5)` 寫入 `CustomShortcut = "F13"`。
- 已同步將 companion app 預設快捷鍵改成無修飾鍵 `F13`，避免注音輸入法及 Windows 鍵盤的 Command/Option 標示差異。
- 手動從選單列啟動 overlay 已驗證視窗正常建立；硬體快捷鍵測試待使用者在 macOS「輔助使用」中允許 `OpenLogiSpotlight` 後重新啟動 app。

## 2026-09-13 — 公開排錯紀錄

- 踩坑：`OpenLogiAgent.app` 的「輸入監控」與 `OpenLogiSpotlight.app` 的「輔助使用」是兩個獨立權限；只開其中一個時，另一段按鍵鏈路仍會失效。
- 踩坑：macOS 權限清單可能留下同名但不同路徑的 ad-hoc app；應加入安裝後的 `~/Applications/OpenLogiSpotlight.app`，不要加入 `outputs/` 編譯產物。
- 踩坑：授權切換後必須完全重啟對應 app；以選單列 `◉` 與 `Accessibility Permission: Granted` 作為 companion 已準備好的判斷。
- 踩坑：Bluetooth 顯示 LIFT 已連線時，`openlogi list` 仍可能因 background agent 已持有 HID++ channel 而回報無法開啟；不能只用這個 CLI 輸出判定滑鼠斷線。
