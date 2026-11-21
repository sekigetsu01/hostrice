pragma Singleton
import Quickshell

Singleton {
    readonly property string terminal: "kitty"
    // the bar's height (set by the bar): the calculator takes its place at the same size
    property int barH: 22
    // the bar's size on screen, × the original: it stays this size whatever QT_SCALE_FACTOR (mango/config.conf)
    // the launchers and panels are set to
    readonly property real barSize: 1.265
    readonly property real barScale: barSize / (Number(Quickshell.env("QT_SCALE_FACTOR")) || 1)
    // a size in the bar (spacing, icons), scaled to whole pixels
    function barPx(n) { return Math.round(n * barScale); }
}
