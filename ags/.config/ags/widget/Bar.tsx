import { Astal, Gtk, Gdk } from "ags/gtk4"
import { Variable } from "ags"
import { execAsync } from "ags/process"
import { createPoll } from "ags/time"
import Hyprland from "gi://AstalHyprland"
import Battery from "gi://AstalBattery"
import Tray from "gi://AstalTray"

// In your version, reactive properties are usually handled
// by the property names directly or through 'destructuring'
function Workspaces() {
    const hypr = Hyprland.get_default()

    // Using the Gnim-style reactivity:
    // We Map over the workspaces and use the 'bind' property of the object
    return <box cssName="Workspaces">
        {hypr.bind("workspaces").as(wss => {
            const persistent = [1, 2, 3]
            const activeIds = wss.map(w => w.id)
            const allIds = [...new Set([...persistent, ...activeIds])].sort((a, b) => a - b)

            return allIds.map(id => {
                const focusedWs = hypr.bind("focusedWorkspace")

                return <button
                    onClicked={() => hypr.dispatch("workspace", id.toString())}
                    // In Gnim, we use .as() on the bound property
                    cssName={focusedWs.as(ws => ws.id === id ? "focused" : "unfocused")}
                >
                    <label label={hypr.bind("focusedClient").as(client => {
                        const ws = hypr.get_focused_workspace()
                        if (ws && ws.id === id && client) {
                            const title = client.title.length > 20
                                ? client.title.substring(0, 20) + "..."
                                : client.title
                            return `(${id}) ${title}`
                        }
                        return `(${id})`
                    })} />
                </button>
            })
        })}
    </box>
}

function SysInfo() {
    const cpu = createPoll("0", 2000, "bash -c \"top -bn1 | grep 'Cpu(s)' | awk '{print $2}'\"")
    const ram = createPoll("0", 5000, "bash -c \"free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1\"")
    const time = createPoll("", 1000, "date +%H:%M")

    return <button onClicked={() => execAsync("ags -t dashboard")} cssName="SysInfo">
        <box spacing={10}>
            <label label={cpu.as(v => ` ${v}%`)} />
            <label label={ram.as(v => ` ${v}%`)} />
            <label label={time} cssName="Clock" />
        </box>
    </button>
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
    const tray = Tray.get_default()
    const battery = Battery.get_default()

    return (
        <window
            visible
            name="bar"
            cssName="Bar"
            gdkmonitor={gdkmonitor}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
        >
            <centerbox cssName="bar-inner">
                <box halign={Gtk.Align.START} spacing={10}>
                    <button onClicked={() => execAsync("rofi -show drun")}>
                        <label label="" />
                    </button>
                    <Workspaces />
                </box>

                <box halign={Gtk.Align.CENTER}>
                    <SysInfo />
                </box>

                <box halign={Gtk.Align.END} spacing={10}>
                    <box cssName="Tray">
                        {tray.bind("items").as(items => items.map(item => (
                            <menubutton tooltipMarkup={item.bind("tooltipMarkup")}>
                                <icon gicon={item.bind("gicon")} />
                            </menubutton>
                        )))}
                    </box>
                    <button onClicked={() => execAsync("bash -c '$HOME/.config/hypr/scripts/wallpaper-selector.sh'")}>
                        <label label="󰋩" />
                    </button>
                    <label label={battery.bind("percentage").as(p => ` ${Math.floor(p * 100)}%`)} />
                    <button onClicked={() => execAsync("bash -c '$HOME/.config/hypr/scripts/loguot.sh'")}>
                        <label label="" />
                    </button>
                </box>
            </centerbox>
        </window>
    )
}
