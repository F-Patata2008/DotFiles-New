--!nonstrict
-- Bar widget entry for Redmi Buds 8 Lite

local scriptPath = "/home/fpatata/Dotfiles/noctalia/plugins/redmi-buds/scripts/redmi_buds_ctl.py"

local function refresh()
  noctalia.runAsync({ "/usr/bin/python3", scriptPath, "status" }, function(result)
    if result.exitCode == 0 and result.stdout and result.stdout ~= "" then
      local ok, data = pcall(noctalia.json.decode, result.stdout)
      if ok and data and data.connected then
        noctalia.state.set("buds.status", data)
      else
        noctalia.state.set("buds.status", { connected = false })
      end
    end
  end)
end

local function render()
  local status = noctalia.state.get("buds.status")
  if not status or not status.connected then
    barWidget.setVisible(false)
    return
  end

  local left = status.left or 0
  local right = status.right or 0
  local caseLevel = status.case or 0
  local ancName = status.anc_name or "ANC"

  local text = string.format("%d%% | %d%% · %s", left, right, ancName)
  local tooltip = string.format("🎧 REDMI Buds 8 Lite\nLeft: %d%%\nRight: %d%%\nCase: %d%%\nMode: %s\n\n• Left-click: Open Controls\n• Right-click: Toggle ANC Mode", left, right, caseLevel, ancName)

  barWidget.setGlyph("headphones")
  barWidget.setText(text)
  barWidget.setTooltip(tooltip)
  barWidget.setVisible(true)
end

noctalia.state.watch("buds.status", function(_val)
  render()
end)

function onClick()
  noctalia.togglePanel("patata/redmi-buds:panel")
end

function onRightClick()
  noctalia.state.set("buds.cmd", { action = "toggle_anc", ts = os.time() })
end

-- Refresh immediately on widget load
refresh()
render()
