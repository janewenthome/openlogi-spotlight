# Progress

## 2026-09-12

- 專案初始化，目的為建立搭配 OpenLogi 使用的 macOS 簡報聚光燈 companion app。
- 已確認本機為 Apple Silicon macOS 26，並安裝 OpenLogi 0.7.4。
- 已完成架構決策：OpenLogi 負責 Logitech 按鍵 → `⌘⇧9`，本專案負責原生 AppKit overlay。

## 2026-09-12 — MVP

- 完成 `OpenLogiSpotlight.app`：選單列常駐、全域 `⌘⇧9` toggle、`Esc` 隱藏、多螢幕 overlay、游標跟隨與 click-through 視窗。
- `make test` 通過；release build、ad-hoc signed app bundle 與本機安裝流程通過。
- OpenLogi 已由 Homebrew 安裝；目前 CLI 尚未找到可開啟的 Logitech HID++ 裝置，需在實際滑鼠/權限環境驗證。
- 尚未建立 GitHub remote，因 `gh auth status` 顯示尚未登入 GitHub。
