# OpenLogi 按鍵設定

## 安裝與權限

```sh
brew install --cask openlogi
```

請先完全結束 Logitech Options+，兩個程式不能同時擁有同一個 receiver 的 HID++ 存取權。第一次使用 OpenLogi 時，依照它的提示允許輔助使用與輸入監控權限。

## 用 GUI 設定（建議）

1. 開啟 OpenLogi，選取你的 Logitech 滑鼠。
2. 在按鍵/Buttons 設定中選取要作為聚光燈的按鍵，例如 Back、Forward、Middle、DPI Toggle 或裝置提供的其他控制。
3. 選擇自訂快捷鍵/Custom Shortcut，錄製 `⌘⇧9`。
4. 儲存設定後，在文字編輯器中按該滑鼠按鍵，應該會輸入或觸發相同的快捷鍵；再啟動 OpenLogi Spotlight 測試。

## 用 TOML 設定（進階）

OpenLogi 的設定通常位於 `~/.config/openlogi/config.toml`。先讓 OpenLogi GUI 寫出你的實體裝置 key，再在對應的 bindings table 加入類似內容：

```toml
[devices."<your-physical-device-key>".bindings]
Back = { CustomShortcut = "Cmd+Shift+9" }
```

`<your-physical-device-key>` 不能照抄這個範例；它可能是 `unit:<hex>`、`serial:<id>` 或其他由 OpenLogi 寫出的實體 key。若要使用其他按鍵，把 `Back` 換成 GUI 顯示的按鍵名稱。

完成後重新載入 OpenLogi，或重新啟動它。若簡報軟體對 `⌘⇧9` 有自己的功能，可以在 `~/Library/Application Support/OpenLogiSpotlight/config.json` 改用其他未使用的快捷鍵，並同步更新 OpenLogi binding。

## 故障排除

- 聚光燈快捷鍵可用，但滑鼠按鍵無效：檢查 OpenLogi 是否仍在執行、是否與 Options+ 同時開啟，以及 OpenLogi 的 Accessibility/Input Monitoring 權限。
- 滑鼠按鍵有動作但 overlay 不出現：在「系統設定 → 隱私權與安全性 → 輔助使用」允許 OpenLogiSpotlight，然後重新啟動 app。
- 全螢幕簡報蓋住 overlay：退出 app 後重新開啟，確認它是以 `OpenLogiSpotlight.app` bundle 啟動，而不是只執行裸 binary。
