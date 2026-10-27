--!nonstrict
-- Panel entry for Redmi Buds 8 Lite

local scriptPath = "/home/fpatata/Dotfiles/noctalia/plugins/redmi-buds/scripts/redmi_buds_ctl.py"

local function sendCmd(action, mode)
  noctalia.state.set("buds.cmd", {
    action = action,
    mode = mode,
    seq = os.time()
  })
end

local function refresh()
  noctalia.runAsync({ "/usr/bin/python3", scriptPath, "status" }, function(result)
    if result.exitCode == 0 and result.stdout and result.stdout ~= "" then
      local ok, data = pcall(noctalia.json.decode, result.stdout)
      if ok and data and data.connected then
        noctalia.state.set("buds.status", data)
      end
    end
  end)
end

local function batteryRow(title, glyphName, level, color)
  return ui.row({ gap = 8, align = "center", paddingV = 4 }, {
    ui.glyph({ name = glyphName, size = 16, color = color or "primary" }),
    ui.label({ text = title, fontSize = 12, flexGrow = 1, color = "on_surface" }),
    ui.label({
      text = string.format("%d%%", level),
      fontSize = 12,
      fontWeight = "bold",
      color = (level > 20 and "primary" or "error")
    })
  })
end

local function render()
  local status = noctalia.state.get("buds.status") or { connected = false }
  local isConn = status.connected == true
  local left = status.left or 0
  local right = status.right or 0
  local caseLevel = status.case or 0
  local ancMode = status.anc or 1

  local kids = {}

  -- Header
  table.insert(kids, ui.row({ gap = 8, align = "center" }, {
    ui.glyph({ name = "headphones", size = 20, color = "primary" }),
    ui.column({ gap = 2, flexGrow = 1 }, {
      ui.label({ text = "REDMI Buds 8 Lite", fontSize = 14, fontWeight = "bold", color = "on_surface" }),
      ui.label({
        text = isConn and "CONNECTED (RFCOMM 17)" or "CONNECTING...",
        fontSize = 9,
        fontWeight = "bold",
        color = isConn and "primary" or "outline"
      })
    }),
    ui.button({
      glyph = "refresh",
      variant = "ghost",
      controlSize = "sm",
      tooltip = "Refresh Battery Status",
      onClick = function() refresh() end
    }),
    ui.button({
      glyph = "close",
      variant = "ghost",
      controlSize = "sm",
      tooltip = "Close",
      onClick = function() panel.close() end
    })
  }))

  -- Divider
  table.insert(kids, ui.box({ height = 1, fill = "outline/0.2" }))

  if isConn then
    -- Battery Levels
    table.insert(kids, ui.column({ gap = 2 }, {
      batteryRow("Left Earbud", "ear", left, "primary"),
      batteryRow("Right Earbud", "ear", right, "primary"),
      batteryRow("Charging Case", "box", caseLevel, "secondary")
    }))

    -- Divider
    table.insert(kids, ui.box({ height = 1, fill = "outline/0.2" }))

    -- Noise Control Section
    table.insert(kids, ui.label({
      text = "ACTIVE NOISE CANCELLATION",
      fontSize = 10,
      fontWeight = "bold",
      color = "outline"
    }))

    table.insert(kids, ui.row({ gap = 6, align = "center" }, {
      ui.button({
        text = "ANC",
        glyph = "shield",
        variant = (ancMode == 1 and "primary" or "outline"),
        flexGrow = 1,
        controlSize = "sm",
        onClick = function() sendCmd("set_anc", 1) end
      }),
      ui.button({
        text = "Off",
        glyph = "volume",
        variant = (ancMode == 0 and "primary" or "outline"),
        flexGrow = 1,
        controlSize = "sm",
        onClick = function() sendCmd("set_anc", 0) end
      }),
      ui.button({
        text = "Transp",
        glyph = "ear",
        variant = (ancMode == 2 and "primary" or "outline"),
        flexGrow = 1,
        controlSize = "sm",
        onClick = function() sendCmd("set_anc", 2) end
      })
    }))
  else
    table.insert(kids, ui.column({ gap = 6, align = "center", paddingV = 20 }, {
      ui.glyph({ name = "bluetooth-off", size = 32, color = "outline" }),
      ui.label({ text = "Querying buds status over Bluetooth...", fontSize = 11, color = "outline" })
    }))
  end

  panel.render(ui.column({ gap = 12, padding = 16 }, kids))
end

function onOpen(_ctx)
  refresh()
  render()
end

function onClose() end

noctalia.state.watch("buds.status", render)
render()
