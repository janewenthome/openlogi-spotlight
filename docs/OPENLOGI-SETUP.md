# OpenLogi 按鍵設定

## 安裝與權限

```sh
brew install --cask openlogi
```

請先完全結束 Logitech Options+，兩個程式不能同時擁有同一個 receiver 的 HID++ 存取權。第一次使用 OpenLogi 時，依照它的提示允許輔助使用與輸入監控權限。

本專案實際需要兩個不同的 macOS 權限：

| 程式 | 系統設定面板 | 用途 |
| --- | --- | --- |
| `OpenLogiAgent.app` | 隱私權與安全性 → 輸入監控 | 讓 OpenLogi 讀取 Bluetooth 直連的 LIFT 按鍵 |
| `OpenLogiSpotlight.app` | 隱私權與安全性 → 輔助使用 | 讓 companion 收到全域 F13 |

安裝腳本產生的 companion 路徑是 `~/Applications/OpenLogiSpotlight.app`。不要把 `outputs/OpenLogiSpotlight.app`（編譯產物）誤加到權限清單。

## 用 GUI 確認按鍵（建議）

1. 開啟 OpenLogi，選取你的 Logitech 滑鼠。
2. 在按鍵/Buttons 設定中選取要作為聚光燈的按鍵，例如 Back、Forward、Middle、DPI Toggle 或裝置提供的其他控制。
3. 截圖中的 OpenLogi v0.7.4 GUI 目前只有內建動作，沒有顯示 Custom Shortcut；請不要在這個選單裡找 `⌘⇧9`。
4. 先記下你要使用的按鍵名稱。你的目前裝置是 `LIFT For Business`，截圖選取的是 `Forward (側鍵 5)`。

## 用 TOML 設定（進階）

OpenLogi 的設定通常位於 `~/.config/openlogi/config.toml`。請先完全結束 OpenLogi，再在對應的 bindings table 加入類似內容。`F13` 是本專案選用的無修飾鍵，不受注音輸入法、Command/Option 鍵盤標示或鍵盤配置影響：

```toml
[devices."<your-physical-device-key>".bindings]
Back = { CustomShortcut = "Cmd+Shift+4" }
Forward = { CustomShortcut = "F13" }
```

`<your-physical-device-key>` 不能照抄這個範例；它可能是 `unit:<hex>`、`serial:<id>` 或其他由 OpenLogi 寫出的實體 key。若要使用其他按鍵，把 `Forward` 換成 GUI 顯示的按鍵名稱。

完成後重新啟動 OpenLogi 與 OpenLogi Spotlight。OpenLogi Spotlight 的設定檔位於 `~/Library/Application Support/OpenLogiSpotlight/config.json`；若要改用其他 F13–F20，必須同步修改兩邊。

## 故障排除

- 聚光燈快捷鍵可用，但滑鼠按鍵無效：檢查 OpenLogi 是否仍在執行、是否與 Options+ 同時開啟、`OpenLogiAgent.app` 是否有「輸入監控」，以及 `config.toml` 是否真的有 `Forward = { CustomShortcut = "F13" }`。
- 選單列仍是 `⚠️`：這是 companion 的「輔助使用」狀態，不是 OpenLogiAgent 的「輸入監控」狀態。請在輔助使用中移除舊的 `OpenLogiSpotlight.app` 項目，再加入 `~/Applications/OpenLogiSpotlight.app`，最後退出並重新開啟 companion；成功時會顯示 `◉`。
- 滑鼠按鍵有動作但 overlay 不出現：先從 companion 選單按 `Show Spotlight (F13)`。若手動可用，表示 overlay 正常，問題在 OpenLogi → F13 的按鍵鏈路；若手動也不可用，先處理 companion 的輔助使用權限。
- Bluetooth 顯示 LIFT 已連線，但 `openlogi list` 顯示 `Failed to open device`：若 OpenLogi background agent 已在執行，CLI 可能與 agent 爭用 HID++ channel；先完全退出 OpenLogi 再查詢，不能只用這個 CLI 結果判定 Bluetooth 斷線。
- 全螢幕簡報蓋住 overlay：退出 app 後重新開啟，確認它是以 `OpenLogiSpotlight.app` bundle 啟動，而不是只執行裸 binary。
