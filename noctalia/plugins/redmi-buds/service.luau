--!nonstrict
-- Service entry for Redmi Buds 8 Lite (Patata / Noctalia v5)

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
    else
      noctalia.state.set("buds.status", { connected = false })
    end
  end)
end

-- Command handler from panel or widget
noctalia.state.watch("buds.cmd", function(cmd)
  if not cmd or not cmd.action then return end
  if cmd.action == "set_anc" then
    local mode = tostring(cmd.mode or 1)
    noctalia.runAsync({ "/usr/bin/python3", scriptPath, "set-anc", mode }, function(_res)
      refresh()
    end)
  elseif cmd.action == "toggle_anc" then
    noctalia.runAsync({ "/usr/bin/python3", scriptPath, "toggle-anc" }, function(_res)
      refresh()
    end)
  elseif cmd.action == "refresh" then
    refresh()
  end
end)

-- Update interval: 20 seconds
noctalia.setUpdateInterval(20000)

function update()
  refresh()
end

function onEnable()
  refresh()
end

refresh()
