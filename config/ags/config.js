// AGS
import Gdk from "gi://Gdk";
import GLib from "gi://GLib";
import App from "resource:///com/github/Aylur/ags/app.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

// Custom modules
import { Bar } from "./modules/bar/bar.js";
import { NotificationPopups } from "./modules/notification-popups/notificationsPopup.js";

const COMPILED_STYLE_DIR = `${GLib.get_user_cache_dir()}/ags/user/generated`;
// const range = (length, start = 1) =>
//     Array.from({ length }, (_, i) => i + start);
// function forMonitors(widget) {
//     const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
//     return range(n, 0).map(widget).flat(1);
// }

async function applyStyle() {
    Utils.exec(`mkdir -p ${COMPILED_STYLE_DIR}`);
    Utils.exec(
        `sass ${App.configDir}/style/main.scss ${COMPILED_STYLE_DIR}/style.css`,
    );
    App.resetCss();
    App.applyCss(`${COMPILED_STYLE_DIR}/style.css`);
    console.log("[LOG] Styles loaded");
}
applyStyle().catch(print);

App.config({
    onConfigParsed: () => {
        Utils.monitorFile(`${App.configDir}/style`, function () {
            applyStyle();
        });
    },
    windows: [Bar(0), NotificationPopups()],
    style: `${COMPILED_STYLE_DIR}/style.css`,
});

// forMonitors(Bar);
