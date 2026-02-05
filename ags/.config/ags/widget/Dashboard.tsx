import { Astal, Gtk, Gdk } from "astal/gtk4"
import { bind, Variable } from "astal"
import { execAsync } from "astal/process"
import Mpris from "gi://AstalMpris"
import Notifd from "gi://AstalNotifd"

export default function Dashboard() {
    const mpris = Mpris.get_default()
    const notifd = Notifd.get_default()

    return (
        <window
            name="dashboard"
            className="Dashboard"
            visible={false}
            application={App} // Reference to your main app
            anchor={Astal.WindowAnchor.TOP}
            keymode={Astal.Keymode.ON_DEMAND}
        >
            <box className="dashboard-container" spacing={20} css="padding: 24px;">
                {/* LEFT COLUMN: Media & Notifs */}
                <box vertical spacing={10} widthRequest={300}>
                    <label label="Media" className="section-title" halign={Gtk.Align.START} />
                    {bind(mpris, "players").as(players => players.length > 0 ? (
                        <box vertical className="media-box">
                            <label label={bind(players[0], "title")} />
                            <label label={bind(players[0], "artist")} className="artist" />
                        </box>
                    ) : <label label="No Media Running" />)}

                    <box hexpand vexpand /> // Spacer

                    <box spacing={10}>
                        <label label="Notifications" className="section-title" />
                        <button 
                            className="format-button"
                            onClicked={() => notifd.get_notifications().forEach(n => n.dismiss())}
                        >
                            <label label="Format All PCS" />
                        </button>
                    </box>
                    {bind(notifd, "notifications").as(ns => (
                        <box vertical spacing={5}>
                            {ns.map(n => <label label={n.summary} className="notif-item" />)}
                        </box>
                    ))}
                </box>

                {/* RIGHT COLUMN: Calendar & Weather */}
                <box vertical spacing={10} widthRequest={300}>
                    <Gtk.Calendar halign={Gtk.Align.CENTER} />
                    <box className="weather-box" vertical>
                         <label label="Weather" className="section-title" />
                         {/* Insert your weather script here */}
                         <label label="Santiago: 28°C ☀️" /> 
                    </box>
                </box>
            </box>
        </window>
    )
}
