# Your system
> Every feature, key and tool, by section. Keys are in green; Super is the Windows key.

## How it all fits together

> How the system fits together, the keys to learn first, and where things live.

### The pieces

| System | Arch Linux on a laptop, with the **mango** tiling desktop
| Shell | A self-built **Quickshell**: the launcher, panels, notifications, lock screen and the top bar
| Colours | From the wallpaper, everywhere (pywal; the browser follows through Pywalfox). Except the meaning colours in the bar and panels: green, red and orange are always green, red and orange (good, bad, careful), in the wallpaper's own tone so they sit among its colours; critical pop-ups are red
| A new wallpaper | Its colours are ready at once (wallpaper warm works them out ahead of time, in the background: at login, when the selector opens, after each change). A colour too dark to read on the background is lightened just enough (same hue)
| What changes with it | Open apps, no restart: the bar and panels, window borders, terminals (and yazi and kp in them), Neovim, sioyek, btop, mpv, Glide and swayimg; fzf in open shells from the next prompt. GTK and Qt apps keep their own colours
| Keys | Almost everything is keyboard-driven, with vim-style keys. **Super** is the Windows key

### The keys to learn first

| Super+Return | Terminal
| Super+d | App launcher (type to search, Enter to open)
| Super+w / Super+r / Super+s | Browser (Glide) / files (yazi) / PDF reader (sioyek)
| Super+q | Close the window
| Super+1 … 9 | Go to workspace 1–9 (Super+Tab: back to the last one)
| Super+Shift+p | Screenshot tool
| Super+v | Virtual machines (virt-manager)
| Super+Shift+m or Play key | Pause everything playing (audio, video); press again to resume
| Super+BackSpace | Power menu: lock, reboot, shut down
| ? (in Glide) | Show that app's key list
| Super+F9 | Open this guide (System Guide.pdf in ~/Documents)

### Where things live

| ~/Documents | Documents, and this guide (System Guide.pdf; its source is in ~/Documents/.system-guide)
| ~/wallpapers (night/ subfolders) | Wallpapers; night/ ones are used at night (another folder can be picked in the wallpaper selector)
| ~/.config/wal | How the wallpaper's colours are written into every app's format (templates/, into ~/.cache/wal, by pywal when the wallpaper script runs it) and what's refreshed after (postrun)
| ~/.config/times.conf | All timings: night wallpapers, night mode (red screen and dimming); edit with settimes
| ~/Downloads, ~/Videos, ~/Pictures/Screenshots | Downloads, screen recordings, screenshots (yt and yta download into the folder you're in)

## Desktop: mango window manager

> mango arranges the windows for you. Keys for apps, windows and workspaces, and what starts at login.

### How windows behave

| Tiling | The newest window goes in the big 'master' area on the left (58% of the screen); the rest stack on the right
| Workspaces | Called tags (1–9)
| Focus | Follows the mouse; the cursor jumps to the window you pick with the keyboard and hides when idle
| Keyboard | UK layout, fast key repeat, Num Lock on
| Touchpad | Natural scrolling (the page follows your fingers, like a phone); a mouse wheel scrolls the usual way
| The laptop's screen | Not scaled (scale 1): the bar and panels are drawn bigger by themselves (the panels 25%), and kitty has its own larger text
| Other monitors | Scaled so things look the same size as on the laptop, worked out from each screen's real size and how far away you sit (70 cm for an external monitor). An ultrawide gets more room with the same-looking text. Monitors plugged in later are scaled too (~/.config/mango/scripts/autoscale)
| A monitor too big or small | Put its name and a scale in ~/.config/mango/scale-overrides, one per line (e.g. DP-1 1.25): a set scale always wins

### Open apps and tools

| Super+Return | Terminal (kitty)
| Super+d | App launcher
| Super+w | Glide browser
| Super+r | yazi file manager (a text file you open takes over its window in nvim)
| Super+s | sioyek PDF reader (another press opens another window)
| Super+f | Make the focused window as big as the screen, with the bar still showing (press again to undo)
| Super+Alt+f | Real fullscreen, hiding the bar (press again to leave)
| Super+Shift+r | btop system monitor
| Super+F4 | wiremix (audio mixer): h / l or a click / drag on a volume bar sets it; scrolling sideways over one (touchpad swipe, tilt wheel) changes it 1% a step; the up / down wheel moves through the list
| Super+F5 | Wifi menu (see Quickshell panels)
| Super+Shift+d | kp password manager: opens it, or hides / brings back the open one (it stays unlocked)
| Super+b | Random wallpaper (day or night); hold it to keep changing
| Super+u | VPN on / off: connects (vp) in a terminal on tag 9 while you stay where you are, fetching a fresh config first if the saved one is missing or about to run out. No password (the very first time a small window asks for it once)
| Super+Shift+s | Wallpaper selector
| Super+` (grave) | Emoji picker
| Super+' (apostrophe) | Calculator and unit/currency converter
| Super+F3 | Time zone picker
| Super+c | Calendar
| Alt+r | Reminders for today, in a floating Neovim (again: saves and closes it; open but not focused: brings it to you)
| Alt+BackSpace | Close the reminder on screen (that's it done); with no reminder showing, the newest pop-up
| Super+Shift+n | Notification center
| Super+BackSpace | Power menu
| Ctrl+Alt+l | Lock the screen
| Super+F9 | This guide

### Virtual machines

> The virtual machines run in QEMU/KVM; their windows are virt-manager's.

| Super+v | virt-manager (Virtual Machine Manager): the list of virtual machines
| Super+a | The archlinux machine's window
| Super+p | The publicarchlinux machine's window
| Super+n | The Whonix-Gateway machine's window
| Super+Shift+w | The Whonix-Workstation machine's window
| Again | With that window already open, pressing its key again also starts the machine if it's off (or carries on a paused one); the first press only opens the window
| Couldn't start | A notification says why

### Windows

| Super+q | Close the focused window, straight away (Neovim saves as it closes)
| Super+j / Super+k | Focus next / previous window
| Super+Shift+h j k l | Swap the window left / down / up / right
| Super+h / Super+l | Window narrower / wider
| Super+Space | Move the focused window into the master spot
| Super+i / Super+o | One more / one fewer window in the master area
| Super+t / Super+Shift+t / Super+Shift+c | Tile / vertical tile / grid layout
| Super+Shift+a | Gaps on / off
| Super+z / Super+x | Gaps bigger / smaller

### Workspaces (tags)

| Super+1 … 9 | Go to tag 1–9 (pressing the one you're on does nothing)
| Super+Shift+1 … 9 | Send the window to tag 1–9 and stay here
| Super+Tab | Back to the tag you were on before
| Super+g / Super+; | Tag to the left / right
| Super+Shift+g / Super+Shift+; | Send the window to the tag left / right
| Super+scroll | The tag to the left / right (up / down) that has windows
| Super+0 | Overview: every tag's windows at once (again: back). Not from a screen corner

### Sound, media, screen

| Super+. / Super+, (or volume keys) | Volume up / down 5%
| Super+m (or mute key) | Mute on / off
| Brightness keys, or Super+Up / Super+Down | Screen brighter / darker, 10% a press
| Super+Right / Super+Left | Red screen (night light) stronger / weaker, 10% a step, any time of day (until the morning: night_end and dim_end turn it off); all the way down turns it off. A note shows the level
| Night mode | From 01:00 to 05:00 the screen goes 40% red and as dark as it goes; at 06:00 it's back to full brightness (times in times.conf). Never straight after switching the laptop on: started after 01:00, the screen stays normal that night
| Super+= (or Super++) / Super+- | Terminals fully solid / back to see-through (the default); new terminals open the same way. kp is always solid
| Super+Shift+m (or Play key) | Pause all: pauses every player and remembers them (adding to any paused earlier); a press with nothing playing resumes them all
| Super+Shift+p | Screenshot tool
| Super+F1 | Start / stop screen recording (with desktop sound). While it records (not while paused), a red dot shows on the bar after the window's title
| Super+Shift+F1 | Record a region you draw
| Super+Ctrl+F1 | Record the screen with notifications still popping up (usually they're held back so they're not in the video). Super+F1 stops it too
| Super+F2 | Pause / carry on recording
| Super+F6 | Auto-clicker on / off
| Super+Shift+F6 | Set the auto-clicker's speed and button
| Super+F10 | Record a macro: name it (Enter for 'last'), the window hides, then everything you type, click and move the mouse to is recorded. Super+F10 again stops and saves it
| Super+F11 | Your macros, newest first, with each one's steps beside it. j/k move (nothing to type), Enter plays it once, Shift+Enter loops it forever, Shift+R asks how many times (5) or how long (30s, 10m, 1h), Shift+D deletes it
| While one plays | You see the pointer glide between points. Super+F11 again stops it. Holding Super pauses it and lets go of every key, so nothing it types turns into a shortcut; letting go carries on
| Super+Shift+F11 | Play the last macro again, once (again: stops it)
| Again | Any key that opens the clicker's window closes it on a second press
| clicker check | In a terminal: says what's stopping the clicker, if anything
| Next / previous keys | Next / previous track in any player
| Super+Alt+Shift+r | Reload the mango config (saving the file also reloads it)

### At login it starts

| Quickshell | Panels, notifications, lock screen, top bar
| Link cleaner | Removes tracking from links you copy
| Helpers | The previous-tag tracker for Super+Tab, the watcher that brings a window asking for attention (mm attention), a hidden kitty that new terminals open in (instant terminals), your timings from times.conf, and the screen scaling
| Timers | The night switch (night wallpapers from 21:00 to 05:00), night mode (red and dim screen, see above); their times are in times.conf
| wallpaper warm | Works out the colours of any wallpaper not seen yet, quietly, so changing wallpaper is instant

### Window behaviour

| Always floating | At a fixed size: kp, reminders, the clicker, the VPN password window and the mpv audio player. Reminders stay above other windows
| Windows come to you | Anything that brings up a window on another tag (kp, an app asking for attention) moves it onto the tag you're on, instead of taking you to its tag; a floating one (kp…) comes back in the middle. The VPN terminal stays on tag 9
| Links | A link or HTML file from another app (the terminal, xdg-open) opens as a new tab in the Glide you have (the window you used last), and you go to its tag; Glide stays where it is. No Glide open: a new window on the tag to your left if it's empty, else the nearest empty tag to the right, else the tag you're on. From Glide itself, a new tab
| Floating windows | The fixed ones above appear and disappear without sliding; pictures (swayimg) open straight in place too
| How | Plain mango (updated by update like everything else): the scripts move the window with mmsg (mm bring), and mm attention, started at login, brings windows that ask for attention (focus_on_activate=0 in the mango config, so they're only marked urgent)

## Top bar

> Left: workspaces and the window title. Right: system status. Colours follow the wallpaper.

| Workspaces 1–9 | Click to switch
| Window title | [layout] and the title of that monitor's window (or its app name), cut to 24 letters
| CPU: n% | Hover: the CPU's model, cores and threads. Click: CPU dashboard (model, speeds, temperature, per-core bars, busiest programs; q closes)
| Mem | Memory used (GiB). Hover: used / total. Click: btop
| Disk | Free space on /. Hover: used out of total (%). Click: ncdu (find what's using space)
| Volume | Left-click wiremix · middle-click mute · scroll 1% a step (up to 150%) · hover: the output device. Muted: dimmed, reads Muted
| Network | Wi-Fi name (long ones cut, the full name on hover), Wired, Disconnected or ⚠ Disabled (Wi-Fi switched off). Click: the wifi menu
| Battery | Its charge, green while charging or plugged in, orange at 30% or less, red and blinking at 20% or less. Hover: time left (or until full; plugged in, also how long the charge would last on battery, once it has run on battery). At 15% and not charging you get one warning
| Date | Click: calendar
| Time | Click: power menu
| VPN padlock | Shown while a VPN is up. Left-click: where you appear, your IP, the server, how long it's been up and whether the kill switch is on · right-click: leak test (route, IP, IPv6, DNS); hover: VPN active. Warns if the VPN drops
| Tray | Icons of running apps. Click: open it · right-click: its menu · middle-click: its second action · hover: its tooltip

## Quickshell panels

> Panels open with the keys in the Desktop section. Opening one closes any other (the calendar left on another tag too). Esc closes it (the screenshot tool steps back a stage first), as you let go of the key, so the window underneath never gets the Esc too (a fullscreen video stays fullscreen).

### Search lists (apps, emoji, time zones, wifi)

| Type | Fuzzy search: the letters in order, not necessarily together; matches are highlighted
| Esc | Once: leave the search box and use the list with single keys (Esc there clears the search). On an empty search: close
| Enter / click | Use the selected row
| Up/Down, Ctrl+j/k (typing), j/k (list mode) | Move
| Ctrl+s, or Space in list mode, or click ☆ | Favourite, pinned to the top (apps, emoji, time zones, wifi)
| / f i a (list mode) | Back to the search box

### App launcher (Super+d)

| List | Every installed app: favourites first, then the ones you use most and most recently; while you type, the matches, best first (favourites still at the top)
| Hidden apps | Not shown (see apphide in Tools)

### Emoji (Super+`)

| Search | By description; Enter copies the emoji to the clipboard

### Calculator (Super+')

| Where | A panel down the left side of the screen, the same height as the windows (the bar stays clear); the windows move over to make room beside it, so nothing hides behind it. Over a full-screen window it goes on top, the full height of the screen and covering that window's edge; when the window leaves full screen it goes back to its usual size. The box, the answer large with how many numbers it adds up, and recent sums filling the rest. It opens straight there, with the keyboard in it
| Typing elsewhere | It stays open while you type in a window: Super+h / Super+l away from the calculator's side (Super+l when it's on the left), or click a window (that first click hands the keyboard over; click again to put the cursor where you want). Back to it: click it, Super+h / Super+l towards it, or Super+j / Super+k (below). Super+' closes it; so does Esc while it has the keyboard (while a window has it, Esc goes to the window). With it closed, Super+h / Super+l resize as usual
| Alone on the tag | With no window on the tag it always has the keyboard (closing the last window, or going to an empty tag, gives it back)
| Which has the keyboard | The calculator: it has a coloured frame. A window: the calculator is dimmed
| Super+j / Super+k | The calculator is one of the windows they step through, from anywhere: Super+j from the last window, or Super+k from the first, goes to it; from it, Super+j goes to the first window and Super+k to the last. With one window they switch between it and the calculator
| Window keys | While it has the keyboard it moves like a window: Super+Shift+h / Super+Shift+l put it on the left / right, Super+space swaps its side; Super+Shift+j / k go to the windows and move them. While a window has the keyboard, these work on the windows as always
| Shift+h or Shift+f / Shift+l or Shift+j | With the box empty: move it to the left / right side; it stays there until a restart, then it's back on the left (in a sum they're capital letters, as in JPY)
| Sums | Live answer as you type: + - * / (or x) ^ ( ) sqrt(), 5% = 0.05, and a percentage added or taken off is a share of what comes before it (200+10% = 220, 200-10% = 180); commas added for you; spaces never needed. A list of numbers added up shows "5 items" ("…, 2 multiplied" for ones like 80x2)
| Money in a sum | 10%x$500 = $50, £12.50x3+£4 = £41.50: worked out as numbers, the answer with the symbol. Two different symbols ($5+£3) ask you to say which to show it in ('… to £')
| Enter or Tab | The answer replaces the sum in the box (the sum is kept under recents), to carry on from it (e.g. then +50)
| Shift+Enter · Esc | Done, with the answer copied (a note says what) and the sum kept under recents · close
| Ctrl+← → · Ctrl+Backspace / Delete | Jump by word · delete a word: an amount with its commas, point and symbol ($32,000) counts as one word, so it goes to its start or end, not the comma (Shift with the arrows selects)
| Ctrl+s (add up a selection) | Highlight lines (in nvim with V or the mouse; in the terminal with Shift+drag; or in the browser), open the calculator, Ctrl+s: every price is pulled into the box as a sum you can still edit. Per line it takes the number after £ $ € ¥ ₹ (lines without a price are skipped then, so "X13" or "34 Inch" never count), else the last number on its own; "x2" or "2x" multiplies it. The answer shows the £
| ans | The last answer: 'ans/12', 'ans*1.2', 'ans gbp to usd'. Under the answer it says what ans is while you use it
| Up / Down · click · Ctrl+d | Reuse past sums (50 kept, all in the list): click one, or step through them with Up/Down · clear that history
| Units | '5 km to mi', '5 kg' (gives lb and st), '5 ft 3 in in cm', '1 st 4 lb in kg'; shows the formula
| Kinds of unit | Length, area, volume, mass, speed, time, data, energy, power, pressure, angle, frequency, temperature, fuel economy
| Currency | '50 usd to gbp' or '$50 to £', spaces optional ('50usdtogbp', '$50to£'; '10kmin miles' for units too). Symbols too: $ £ € ¥ ₹ A$ C$ NZ$ zł…; and names: '50 pounds to yen', '20 dollars in euros' (yen, dollars, euros, quid, rupees, yuan, won, francs, pesos…). Just the currency after it converts too: '£50 yen', or '£50 y' (y and pounds mean yen and £ only beside money; '5 y to days' is still years, '5 pounds' still lb). 31 currencies, and any other code the downloaded rates have. The answer shows its symbol; yen, won and a few others in whole numbers
| An amount on its own | '£50' (or '50 eur', '3x£12.50') shows it in yen underneath, with the rate; a dollar or yen amount shows pounds
| Exchange rates | Only downloaded when you ask: once the saved ones are over 12 hours old (or there are none), a currency sum shows Update rates bottom right with the day they're from; click it (or Ctrl+u). Until then, and offline, the last rates are used; your answer fills in once they arrive. They're asked for as a plain Firefox would, nothing that names the calculator
| Trying the old-rates button | `~/.config/quickshell/launcher/calc/fx stale` makes the saved rates look 13 hours old; open the calculator, type a currency sum (e.g. 50 usd to gbp) and Update rates shows, as it will every 12 hours

### Calendar (Super+c, or click the date)

> A month to look at and the time around the world. It has no events, agenda or to-dos.

| Left | The month, with the picked day highlighted and today ringed; the picked day's full date under it
| Right | The time now, large, with today's date under it; then the time in London, New York, California and Tokyo, each with how far it is from yours (+9h, −5h, same)
| Your time zone | Read again each time it opens, so a change with Super+F3 shows straight away (summer time too)
| Stays put | It stays on the tag you opened it on: go to another tag and it hides, come back and it's there as you left it
| h / l or ← → | A day back / on
| j / k or ↓ ↑ | A week on / back
| H L / [ ] / PgUp PgDn | Previous / next month
| t | Today
| Mouse | Click a day to pick it · ◂ ▸ beside the month's name or scrolling over it: change month
| Esc | Close
| Other places | The four places are set at the top of ~/.config/quickshell/calendar/CalendarPanel.qml (a name and its time zone)

### Time zones (Super+F3)

| List | Every country (one row per region where a country has several zones: Canada · Vancouver, Australia · Perth), US states and big cities, and UTC; each with its current time
| Search | A country, city, region or zone name (Europe/London, "Pacific", UK); or an offset: +9, utc-5, gmt+5:30 shows every zone at that offset
| Enter | Sets the system time zone (through timedatectl, so open apps hear about it). No password: the very first time it asks once to put its small helper in place (/usr/local/lib/tz-root, copied from ~/.local/lib/tz-root and allowed by /etc/sudoers.d/timezone); it asks again only if that helper changes

### Wifi (Super+F5, or click the network in the bar)

> NetworkManager's networks and wired connections, fully opaque. Connected first, then starred, then saved, then by signal. On a machine without wifi it only shows wired ones.

| Rows | A signal fan whose fill shows the strength (green on the connected network), a green "connected" pill or a grey "saved", the signal in %, and a lock on secured networks, in lined-up columns
| Search bar icon | The connected network's signal fan; an outline when not connected, crossed out with wifi off

| Enter | Connect (a new network with a password asks for it: Enter connects, Ctrl+h shows what you typed); on the connected one: its details
| Tab | Details: security, signal, the saved password (v shows it, Ctrl+c copies it) and the address
| Ctrl+d | Disconnect
| Ctrl+f | Forget a saved network
| Ctrl+r | Scan again (the list also refreshes by itself every 15 seconds; nmcli scans again at most every 30)
| Ctrl+w | Wifi on / off
| Space / Ctrl+s | Star a network: starred ones stay near the top

### Power menu (Super+BackSpace)

| L or 1 · R or 2 · S or 3 | Lock · reboot · shut down, straight away (no confirmation)
| Esc | Close

### Lock screen

| Locks | From the power menu or with Ctrl+Alt+l
| By itself | After 45 minutes without keyboard, mouse or touchpad; not while something keeps the screen awake (a playing video, a fullscreen app)
| Unlock | Type your password and Enter. Shows a clock and how long it's been locked
| On lock | Pauses media, mutes sound, wipes the clipboard, closes kp, locks KeePassXC
| On unlock | Unmutes and resumes what it paused

### Reminders (Alt+r)

> For today only: under 24 hours away.

| How | Alt+r opens the reminders still to come, one per line, with a new line to type on: what, then when. :wq sets them (:q with nothing typed just closes). Alt+r again saves and closes it (not focused: brings it to you)
| Times | A clock time: walk 14:00, 14:00:30, 2pm, 2:30pm. Or how long from now: walk 30s, 5m, 1h, 1h30m (s seconds, m minutes, h hours), or written out: 30 sec, 5 min, 1 hr 30 min, in 10 mins. The time can go first too (5 min tea); a clock time can end in tomorrow (walk 9:00 tomorrow) if that's under 24 hours away
| On save | Each line becomes the clock time it goes off (walk 5 min → walk 14:35:12), so what you see is what's set
| Refused | A clock time that's already passed today, 24 hours or more, or a line with no time: the window stays open with why, and the line stays for you to fix (:q! drops it; the others are set)
| Change / cancel | Edit the line's time / delete the line, then save
| When it's due | A notification that stays until you close it: click it or Alt+BackSpace (that's it done)
| Snooze 5 min | Button on the notification: back in 5 minutes
| Snooze… | Button on the notification: opens the window with the reminder on a new line to type the new time after (closing without one brings the notification back)
| Restart / reboot | Kept in ~/.local/state/reminders.json: still to come ones carry on; ones due while it was off, or not closed, come up as soon as the bar starts
| Screen recording | Held back like other pop-ups, and shown when the recording ends (not in a Super+Ctrl+F1 recording: they come up as usual)

### Notifications

| Pop-ups | Top right, up to three at once, newest on top: small cards in the wallpaper's colours, the app name above a title line and up to two lines of text, each only as tall as its text needs (longer text ends in …; the notification center has all of it)
| How long | 1.5 s each, always, whatever the app asks for; a line along the bottom counts down. Everything also goes to the notification center
| Pointer on them | Pauses them where they are: none closes or moves, and new ones wait until the pointer leaves. Moving off, each carries on from where it was (a second at least)
| Left / middle / right click | Close one / open the notification center (closing that one) / close them all but the reminders
| Alt+BackSpace | Close the reminder on screen (that's it done); with no reminder showing, the newest pop-up
| +N more | Under them when there are more than three: opens the center and clears the pop-ups
| Urgency | Low: plain (no accent bar) · normal: the accent bar · critical (errors, a low battery): an accent border. Every pop-up leaves on its timer and stays in the center, except reminders (Alt+r), which stay until closed or snoozed
| Repeats | The same message again within 10 s, while it's still showing, adds ×2, ×3 to that card instead of a new one
| Progress | Downloads and the like update one card with a bar (apps that send a sync tag, or the same text again)
| Always shown | Fullscreen windows don't hold them back
| Screen recording | Pop-ups are held back (so they're not in the video) and counted for afterwards, except in a recording started with Super+Ctrl+F1 (record-screen -s), which shows them; the recorder's own quiet notices (Recording, Paused) go only to the notification center; its errors still pop up. While paused, pop-ups show as usual
| Quiet ones | Skip the pop-up and only go to the center (each kept; ones sharing a sync tag replace each other)
| Per-app rules | ~/.config/quickshell/notifications/rules.json: quiet (center only) for any app; saved changes apply straight away
| Notification center | Super+Shift+n. Each one shows when it came (the time today, else the day and time). Keeps the newest 200, also when the shell reloads (after unlocking, say)
| In the center | j / k (or arrows) move · d or Backspace deletes · Shift+d or Clear All clears all · Esc or Super+Shift+n again closes it

### Screenshot tool (Super+Shift+p)

| Opening it | Freezes the screen
| The dock | Each button's key is printed under it (and in its label when you point at it): p turn it sideways, 1–9 the tools, b solid shapes, z (or click the size) the size slider, [ ] size, u / r undo / redo, a whole screen, d delay; o opens a tool's colours. The same dock is in swayimg's e (draw on a picture)
| Selecting | Drag a box (drag inside to move it, edges to resize), or h j k l to grow it (Shift shrinks, Alt moves the box)
| Enter | Copy the selection (no selection, or a click without dragging: the full screen). Closing with Super+Shift+p or Esc both start the next time fresh (tool, colour, delay)
| c | Copy and save the selection
| s | Save the selection (or the full screen)
| f | Copy the full screen
| a or Ctrl+f (or the corners button) | Select the whole screen, so you can draw over all of it and then copy / save as usual
| t | Read the text in the selection (OCR) and copy it
| d (or the delay button) | Delay 0 → 3 → 5 s: the next capture key counts down, then takes the live screen
| g | Change the rope style
| Esc | Step back: countdown, colour picker or size slider, tool, selection, then exit

#### Drawing

| Dock | Pen, highlighter, box, circle, arrow, text, line and numbered badges
| w / x, or Ctrl+l / Ctrl+h | Next / previous tool
| 1–9 | Pick a tool: 1 move, 2 pen, 3 highlighter, 4 box, 5 circle, 6 arrow, 7 text, 8 line, 9 numbered badges
| b | Solid rectangles and circles, in the colour: to hide things (b again: outlines). With another tool, b picks the rectangle, solid
| z, or click the size button | The size slider: the tool drawn at that size, in its colour (a big one drawn smaller, and says so). Pen, box, circle, arrow and line thickness, the badges' size, the text's size; each tool keeps its own. z or Esc closes it
| [ ], or scroll on the size button | Size a step smaller / bigger (right-click the size button: smaller)
| Sizes as you go | Changing the size also resizes the drawing you just made, as you change it, until you start the next one or pick another tool. With the move tool, the size button, slider, [ ] and scrolling show and change the drawing you picked up
| u or Ctrl+z / r or Ctrl+y | Undo / redo
| p | Dock sideways
| o, or right-click the tool in use | Colours (o again closes them)
| Move tool | Picks up a drawing: arrows move it (Ctrl: further), [ ] its thickness (a badge's size), b makes a box or circle solid or not, Ctrl+= / Ctrl+- a label's size, Delete or Backspace removes it
| Saved to | ~/Pictures/Screenshots
| On a saved image | Press e in swayimg: the same dock and keys; s saves a copy next to it named name-drawn, Enter copies and saves, Esc closes without saving. The original is never changed

### Wallpaper selector (Super+Shift+s)

| What | Browse ~/wallpapers as thumbnails
| h j k l / Enter | Move / open a folder or set the wallpaper
| Backspace / Esc | Go back / go back or close
| r / b | Random wallpaper / random from the highlighted folder
| / (or f i a) · n N · gg G | Search (in the box: Tab / Shift+Tab next / previous, Enter opens, Esc clears) · next / previous · first / last
| m (or s) | Day / night (night uses each folder's night/ subfolder, or its day pictures when it has none; on automatically at night)
| c / Shift+d | Rename the file in yazi / delete it for good (no undo)
| t | Move the picture into this folder's night/ (made if it isn't there), or, in a night/ folder, back out to the folder above. A picture of the same name there is replaced
| Shift+c / Shift+l / Shift+b | Change the layout
| o (or click the folder path at the bottom) | Use a different wallpapers folder: yazi opens; go into the folder and press q (Q cancels)
| Then f / j | Use it until restart / always (or h/l and Enter, 1 / 2, or a click); Esc cancels
| What follows it | Random wallpapers (Super+b) and the night switch use it too
| Back to normal | Choose ~/wallpapers with Always. In a terminal, wallpaper dir shows the folder in use
| No folder, or no pictures | It says so, with a Choose folder button (Enter presses it)

## Clipboard and links

| Links | Copying a web link removes tracking junk automatically (utm, fbclid, gclid, YouTube 'si', Amazon ref and more); a copied picture is left alone
| Passwords | kp clears a copied password after 15 s
| Files | yazi's y copies files so other apps can paste them; Y copies a file's contents (image or text)

## Terminal and shell (kitty + zsh)

> zsh in the kitty terminal, with vim keys at the prompt.

### The prompt

| Vi mode | Esc for normal mode; a block cursor in normal, a line in insert
| Suggestions | Grey, from history (and completions)
| Folders | Typing a folder name goes into it; each change of folder shows a short file grid (hidden files left out)
| History | Shared between terminals; a command starting with a space, over 300 characters or over 3 lines isn't kept; repeats are kept once
| Brackets and quotes | ( [ { " ' and ` close themselves; Backspace on an empty pair removes both

### Keys at the prompt

| Ctrl+o | Open yazi; when you quit, the shell moves to where you were
| Ctrl+f | Find a file (fzf) and go to its folder
| Alt+c | Pick a folder (fzf) and go into it (with text selected, Alt+c copies it instead)
| Ctrl+r / Ctrl+t | Search history / insert a file (fzf)
| Ctrl+e | Edit the command in Neovim
| Ctrl+Space | Accept the grey suggestion
| Up / Down or Ctrl+k / Ctrl+j | Search history for what you've typed
| Ctrl+w / Ctrl+Backspace | Delete the next word / the previous word (in fzf lists' search, both delete the previous word); at prompts that ask you to type (ud's username, send's where-to, Python) the same as in zsh
| Tab | Complete; h j k l move in the list, case doesn't matter, part of a word is enough
| Shift+Enter | Same as Enter
| y / p / P (normal mode) | Copy / paste after / paste before, with the system clipboard
| ci" da( … | Vim text objects work in normal mode

### Handy commands

| cd (zoxide) | Learns your folders: 'cd proj' jumps to the best match; cdi picks from a list (z, zi and c do the same)
| y or l | yazi that leaves you where you quit
| ls | eza with icons, folders first
| rm | Permanent, verbose, handles folders; never asks (read-only files go too)
| cp / mv | Ask before replacing a file, and say what they did
| ex FILE | Extract any archive next to it; into a folder that's already there it merges (same-named files replaced, the rest kept), so the parts of a split download (takeout-001.zip, -002…) add up (zip, 7z and rar through libarchive, tar ones through tar; a lone .gz/.xz/.bz2/.zst file is unpacked next to itself; a password-protected .zip asks for its password)
| mkcd DIR / mkd DIR | Make a folder and go in / make it (with any missing ones above it)
| cm, u, ka, sdn | chmod +x / unzip / killall / shut down now
| mpvl, sy | mpv on a loop / syncthing
| vim, mount, pacman, reboot… | vim is nvim; mount, umount, pacman, su, shutdown, poweroff and reboot run through sudo
| se | Pick one of your scripts and edit it
| yt URL / yta URL [1:00-2:30] | Download video / audio only (optionally a time range) into the folder you're in, named after the title. yt cuts out everything SponsorBlock marks (sponsors, self-promotion, like/subscribe reminders, intros, outros, recaps, filler, non-music). yta keeps the YouTube link and the thumbnail (its cover) in the file and, for a whole song, cuts out the parts SponsorBlock marks as non-music
| cat | bat with line numbers and colours (with an option, like cat -A, the real cat)
| p / Ss / pd | Update system / search packages / remove a package
| g, ga, gcm, gp, gin, gb, gr | git shortcuts (gp force-pushes to origin main; gin / gb / gr: git init / branch main / add origin)
| gcl NAME… | Clones your GitHub repos into the folder you're in (./NAME), one after another, each replacing the folder if it's already there; ones that fail are listed at the end and the rest still clone. Tab completes your repo names for each one (not those already typed). Also user/repo or a full link; git clone options go after the names: gcl NAME --depth 1. Your GitHub username is the one you typed into ud (u in its list); with none saved yet, gcl asks it once
| rs | rsync with progress and resume
| sip / ipa | Public IP / local IP
| xo file | Open it in its default app and go to the window it opened in, on its tag (like o in yazi); the prompt comes straight back
| v, si, i, f | nvim, sioyek, swayimg, fastfetch (in a narrow window without the logo; nothing wraps)
| cfv / cfz / cfm | Edit nvim / zsh / mango config
| vpn / vp | VPN on or off (as Super+u) / start it in this terminal. vpn avoid: countries it never connects to

### Folder shortcuts

| How | Type the shortcut at the prompt: 'yazi' ones open yazi there, the rest just go there
| In yazi | g + the letter shown goes to the same place
| pp · g p | ~/Pictures (yazi)
| wp · g w | ~/wallpapers (yazi); W goes there without yazi
| L · g L | ~/Library (yazi)
| D | ~/Downloads (g d in yazi)
| vd · g v | ~/Videos
| gi · g i | ~/github
| cf / sc / dt / cac | ~/.config / ~/.local/bin / ~/.local/share / ~/.cache
| mh · g m / m | /mnt/hdd / /mnt
| rv | ~/RiseupVPN-OpenVPN

### kitty terminal keys

> kitty, the terminal: the wallpaper's colours, see-through, icons from Hack Nerd Font, Terminess (the Terminus letters). Pictures in notes are part of the text.

| Alt+c / Alt+v | Copy / paste (selecting text alone doesn't copy: it's only for middle-click paste); with nothing selected, Alt+c goes to the program (the shell's folder picker); in Neovim, Alt+v is Neovim's own paste
| Alt+k j / Alt+u d | Scroll a line / half a page
| Alt+Shift+k / Alt+Shift+j | Bigger / smaller text
| Alt+o / Alt+Shift+o | Open / copy a link on screen
| Ctrl+Shift+z / Ctrl+Shift+x | Jump to previous / next prompt
| Alt+Shift+c | Copy the last command's output
| Alt+Return | New terminal in the same folder
| Ctrl+Shift+n / Ctrl+Shift+o / Ctrl+keypad + − | Same as Alt+Return / Alt+o / Alt+Shift+k j

## Files: yazi

> Three columns: parent, current, preview. Vim keys (h j k l), plus these:

| l / Enter | Go into a folder or open a file (opens all selected files; see Opening and previews). A book (PDF, EPUB …) opens in sioyek on the tag you're on and yazi's window closes (a shell it was started from too)
| o | Open the selected files (or the hovered one) with plain xdg-open: each in its default app (yazi stays open). You're taken to the window it opened in, on its tag: a new window, or the app's own already open (an .html goes to the browser's tag)
| Shift+L | Open with…: pick which app opens the file
| y / d / p | Copy / cut / paste (into the hovered folder)
| D | Delete permanently, straight away (no confirm box, no bin)
| F | New file (end with / for a folder)
| A | Make a folder and go into it (like mkcd; a/b/c makes the whole path)
| r | Rename; with several selected (Space, or v to sweep), all their names open in Neovim to rename at once (:%s/.txt/.md/ then :wq; yazi then asks to go ahead: y renames, n renames nothing)
| a | Invert selection
| Esc | Unselect everything, wherever you are: selected files and the y / d marks too (an open find, filter or search closes one per Esc)
| f | Filter as you type (Enter or Esc keeps only the matches; Esc again shows everything)
| i + letter | Jump to the next name starting with it (n/N repeat); the matching letters show as light blocks
| 5j, 12G, 3h, 2gt | Vim counts work: 3h goes up three folders, 2gt goes to tab 2
| g + key | Go to: g top, h home, c ~/.config, d Downloads, Space type a path, f follow a link; p Pictures, w wallpapers, L Library, v Videos, i github, m /mnt/hdd
| m + letter / ' + letter | Save a mark / jump to it (kept after restart); m - clears them all
| s s / s g | Search names / search inside files (quitting in the results leaves the shell in the folder you searched)
| s c / c f | Go to ~/.local / ~/.config
| t / [ ] | New tab / previous, next tab
| z / Z | Find a file or folder with fzf / jump to a folder you've been in (zoxide)
| Ctrl+s | Show hidden files (in folder previews too)
| w / W | Shell here / running jobs (copies, moves, deletes; empty when nothing runs)
| e | Run the hovered script (result as a notification)
| u | Size of the hovered or selected items
| M | Mount / unmount drives
| b | Set the hovered image as wallpaper; on a folder, a random image from it (subfolders too)
| S | Send the selected files to another computer over SSH: asks where (send)
| Ctrl+g | Get files from another computer into the folder you're in: pick them from a list (send get)
| U | Publish the selected folders in ~/github (or the hovered one) to GitHub with ud; what happened stays on screen until Enter
| Y / c F | Copy file contents / copy file name (to give another file the same name: c F on it, then r on the other and Alt+v pastes)
| c m | Change permissions
| c a a / c a p | Make an archive / one with a password (.zip unless you type .7z or .tar.gz; a password only on .zip, AES-256: it opens in 7-Zip, WinRAR, Keka or bsdtar, not Windows' or macOS's built-in unzip)

### Opening and previews

| Images, documents, books | Open as an ordinary tiled window next to yazi; a book opens in sioyek and yazi's window closes
| Text / video / audio | Neovim / mpv / the small audio player. Text files and notes open in nvim in yazi's own window; quitting nvim takes you back to yazi
| Archives · .kdbx · the rest | Extract here with ex (asks for a password if it needs one) · kp on that database (KeePassXC is next in the open-with menu) · the default app
| Previews | Rendered markdown, notes with their pictures in place (notes with no extension too; every picture shows at once, as part of the text: they scroll with it with J / K, and one at the top or bottom edge shows the part that's on screen), folder trees, what's inside archives, unit and .desktop files in colour, audio's cover (the one inside the file; its details if it has none), hex for binaries, git status
| Pasted copies | A copy named 'name_1' takes the original name back once the original is deleted

### yazi as the file picker for other apps

| Used by | Browsers and other apps open yazi to pick and save files
| Opening a file | Enter picks · q cancels
| Saving | Starts in Downloads with the file ready; walk to a folder and q saves there · R saves straight into the folder you last saved to · r renames · D or Q cancels
| Choosing a folder | Go into it and press q · Q cancels

## Writing: Neovim

> Leader is Space. Set up for writing and editing, with a word count, spellcheck and quick definitions.

### Set up for writing

| Spelling | US English spellcheck (UK spellings like colour are marked)
| Layout | Soft wrap (lines break between words), relative numbers; a long line at the bottom shows as much as fits (no @@@)
| Clipboard and undo | System clipboard, persistent undo
| Status line | Word count and reading time
| Private files | No undo file for files in private/, /tmp, /dev/shm or /run/user, and once one is open that Neovim keeps no history (searches, commands, yanks, marks); what came before is kept
| Start | Plain nvim opens a start page: e new file, f find a file, g search inside files, r recent files, c config, q quit. No key hints pop up (Space ? lists the Space keys)
| No swap files | No "Found a swap file" question, and opening a file never waits for Enter
| Closing the window | Super+q saves every changed file as the window closes; text with no file name is thrown away; a file that can't be written (read-only) is kept in ~/.local/state/nvim/rescued and a notification says so

### Keys

| Space y | Copy the file or selection as flowing text (unwraps lines, keeps lists, headings and table rows on their own lines, leaves pictures out)
| Space b | Look up the word (or selected words) in the browser: searches "define WORD" with your default search engine and takes you to the browser
| Space o / Space h | Spellcheck on/off / hide the status line (and bring it back)
| Space N | Line numbers off / on, in this window
| :Goyo | Centre the writing with wide blank margins; the status line with the word count stays (Space h hides it). :Goyo again goes back
| S | Rename every match of the word (or selection) under the cursor: the :%s line comes ready to edit
| s / gs | Jump anywhere on screen by label / select a code block by label (flash); Ctrl+s while searching with / shows labels too
| ds / cs / ys (gS on a selection) | Delete / change / add surrounding quotes or brackets
| c | Change text without overwriting the clipboard
| Ctrl+Backspace (insert, : line) | Delete the previous word
| Space f / Space s | Format the file or selection (shell, JS, TypeScript, CSS, HTML, JSON, YAML, QML; others through their language server, like Lua) / shellcheck a script into a list below; both say when nothing applies
| Space j / Space k | Blank line below / above
| Space w / Space z / Space x | Terminal split / zoom window / open file with default app (saved first; a file with no name says Save it first)
| Space c | Copy the whole file
| Q / ZA / :w!! | Reflow text / save / save a root-owned file
| ZZ / ZQ / :q | Save and quit / quit without saving / quit; with unsaved changes :q says "No write since last change" and stays. :SaveQuit saves every changed file and quits
| Space ? | List the Space keys
| :PackUpdate | Update plugins (update does this for you)

### Automatic

| On save | Blank end lines removed, and trailing spaces too (not in markdown, where two spaces end a line); JS, CSS, HTML and QML auto-formatted
| Word suggestions | Only words already in the file you're writing in (no snippets, no code or path suggestions). They pop up once you start a word (never after a space or a new line) in a solid box with a border, darker than the writing and in the wallpaper's colours, the chosen one on a clear bar
| In the suggestions | Tab / Shift+Tab, Ctrl+j / Ctrl+k or Ctrl+n / Ctrl+p move, Enter or Ctrl+y takes one, Ctrl+e closes it, Ctrl+Space opens it
| Language servers | Install themselves
| Margins and code | Git changes marked in the margin, indent guides, matching brackets in colour, colour codes shown in their colour, brackets and quotes closing themselves, HTML abbreviations (emmet)
| Moving in wrapped text | j / k move by screen line (with a count, by real lines); n / N keep the match in the middle; . on a selection repeats the last change on every line

## Reading: sioyek PDF reader

> PDFs and e-books open here; Super+s opens it. Colours follow the wallpaper. Super+q closes it (q does nothing). Selecting text copies it.

### Moving and viewing

| j / k, Space / Shift+Space | Scroll / a screen down or up
| p | Go to a page
| K / J | Zoom in / out
| S / w | Fit to width / smart fit
| / | Search
| o / O | Open a book with yazi (starts in ~/Library, or home if there's no Library folder) / previous book (Ctrl+j / Ctrl+k move through that list, and every other sioyek list)
| i | Wallpaper colours on/off (F8 does nothing)
| Ctrl+d / Alt+f / Ctrl+n | Two pages / fullscreen / status bar
| f / Ctrl+f / Ctrl+b | Open a link / jump by label / go to definition
| F / Alt+c | Keyboard overview / copy
| Ctrl+t / Ctrl+Shift+t | Back / forward
| Ctrl+r | Reload the file from disk (after it was rebuilt or changed), staying on the same page
| H gh dh · b gb db · m gm · P gp dp | Highlights · bookmarks · marks · portals (add / go / delete)
| ; (with a word selected) | Look up its meaning: searches "define …" with your default search engine (DuckDuckGo) in a new Glide tab and takes you there
| h / l | Scroll left / right
| V | Reading line: j / k move it down / up a line
| : | sioyek's command line
| Enter (with text selected) | Add the text to the markdown note open in Neovim; with none open, to a note named after the book in ~/Documents/notes (made if it isn't there)
| Y | Drag a box round a figure: saved as an image (in ~/Documents/notes/images) and added with the page number to the same note Enter would use

## Web: Glide browser

> Firefox with vim keys. The mode is shown left of the tabs (nor, ins, vis, hint, cmd, op, ign). Press ? for the full key list.

### Pages and tabs

| j k h l / d u / gg G | Scroll / half page / top, bottom
| f / F | Click a link by label / open it in a new tab
| t / x / X | New tab / close tab / reopen closed tab
| J / K | Tab left / right
| Space 1–9 / g0 g$ | Go to tab N / first, last tab
| Ctrl+1–9 | Move this tab to position N
| H / L / r | Back / forward / reload
| o / O | Address bar / in a new tab (in it, Ctrl+j / Ctrl+k move down / up the suggestions)
| b / B | Search bookmarks / in a new tab
| T | Search open tabs
| p / P | Open the link (or search the text) on the clipboard / in a new tab
| s / gi | Focus the site's search box (none: the address bar) / a text box
| yy / yt | Copy the URL / duplicate the tab
| yi / yI / yd | Copy an image / its URL / download it
| Ctrl+f, n / N | Find, next / previous
| gm | Mute the tab
| Space m | Compact mode: hide tabs and address bar until you move to the top
| Space i | Turn Glide's keys off for this site, every time you visit it (remembered; subdomains too). To turn them back on for good: Esc Esc, then Space i
| Esc Esc (or Shift+Esc, or click the mode label) | Keys off / on for now
| Space n / Space q | New tab / close tab
| Ctrl+Left / Ctrl+Right | Previous / next tab
| Space s / Space R | Save the page / reload the config
| s d r z x v (on YouTube) | Go to the page instead of Glide

### Typing in text boxes

| Esc | In any text box: vim editing
| Edits | d and c with w e b $ 0 ^ G gg, dd, cc, D, C, S, x
| u / Ctrl+r | Undo / redo
| yy (Y) / p / o / v V | Copy the line / paste / new line / select (V: the line), then d c y x p
| Focus | Sites can't grab your typing focus by themselves

### Tabs, start page and search

| Tab bar | Works exactly as in Firefox (drag to reorder or out to a new window; tabs shrink as you open more), in your own look: the open tab is a rounded shape joined to the address bar, short dividers between the others, colours from the wallpaper, and the mode label on the left
| Ctrl+1–9 | Moves the tab to that position
| Size | Everything in Glide (tabs, bars and pages) is 15% bigger, since the screen itself isn't scaled
| New tabs | An empty page in the wallpaper's colours (new windows too); a new wallpaper shows on it within a second, no reload needed
| Start tabs | Space T (leader T) makes the open tabs your start tabs: Glide always starts with them, opened all at once as its first tabs (a link it was started with comes first and shows). Another window while Glide is open gets one new tab. Started again just after you closed it (it's still wiping its history), it waits for that to finish (up to 20 s), so it starts afresh with the start tabs. Edit or empty the list in ~/.config/glide/start-tabs (empty: Glide starts on a blank tab)
| Search engines | In the address bar, ddg / sp / 4get + space choose the engine
| Privacy settings | arkenfox, hardened: see Privacy and safety

## Video and audio

### mpv

| h / l | Back / forward 20 s
| j / k | Back / forward 60 s
| o / p | Slower / faster (0.1× a press)
| - / = | Volume down / up (5% a press)
| Click | Pauses / plays (a double-click no longer goes fullscreen)
| The bar | Moving the mouse anywhere over the video shows the controls at the bottom; they hide again when it stops
| ~ / @ | Next / previous chapter
| c | Shows / hides the chapters as a panel on the right, in the playlist's place (one at a time: c while the playlist is up swaps to the chapters). Up again next time if you left it up. A video with no chapters says No chapters
| In the chapters | At the top the title and the chapter you're in (3 / 14). Each row: its number (▶ on the one playing), a frame from its start with its length, a bar for how far into it you are, and its name with its start time and length
| Chapters panel | Click a row to jump to that chapter; the wheel over it scrolls. While it's up: Ctrl+j / Ctrl+k (or ↓ ↑) move, gg / G first / last, Enter jumps there (on the chapter you're in: back to its start), Esc (or c) hides it. Those keys only change while it's up
| s | Subtitles on / off
| Shift+s | Screenshot of the video, subtitles included, into ~/Pictures/Screenshots
| a | Next audio language (never stops on no sound)
| z / x | Zoom in / out
| Online video | Up to 1080p with English subtitles. A video opened from a YouTube playlist (or the playlist's link) brings the whole playlist, starting at that video: Tab shows it
| Slow streams | When a stream runs dry mpv waits until it has 10 s more before carrying on, so it stops less often
| SponsorBlock | On YouTube videos (and downloads that weren't cut) the parts it marks are skipped: sponsors, self-promotion, like/subscribe reminders, intros, outros, recaps, filler, non-music. A note says what was skipped; seek back into one to watch it
| q | Does nothing: Super+q closes it (a video file carries on there next time)
| A folder of videos | Opening one plays the folder from it on, by name, one after another (like a playlist). A video you stop partway carries on there next time; ones watched to the end are remembered
| Tab | Shows / hides the playlist (the folder's videos, or a YouTube playlist) as a panel on the right, like YouTube's, the video moved over to make room. It stays up while you watch, and is up again next time if you left it up (c swaps it for the chapters)
| In the playlist | At the top the folder's name (a YouTube playlist's title and channel) and where you are (3 / 14). Each row: its number (▶ on the one playing), a frame with its length, a bar for how far you got, and its name with the channel (or Watched / time left)
| Playlist panel | Click a row to play it; the wheel over it scrolls. While it's up: Ctrl+j / Ctrl+k (or ↓ ↑) move, gg / G first / last, Enter plays, Esc (or Tab) hides it. Those keys only change while it's up
| Audio files | A small mpv window that plays the rest of the folder; closing it stops the sound

### Images: swayimg

| h l (or j k, or the arrows) | Previous / next image in the folder (in the gallery: move the selection)
| [ ] / g G | Previous / next folder / first, last image
| x z (or + −) / = / 0 | Zoom in, out / 100% / fit
| Shift+h j k l (or Shift+arrows) | Pan
| r R / m M | Rotate / flip
| f / i | Fullscreen / info (hidden at first, in the gallery too; i shows it)
| y / b | Copy the image / set as wallpaper
| c | Copy its full path
| s | Slideshow from here, a new picture every 4 s (h l step); s or Esc stops
| e | Draw on it with the screenshot tool's pens; s saves a copy named name-drawn
| Shift+d | Delete permanently
| Tab / Enter, Space or a click | Thumbnail gallery / open the picture (Ctrl+d Ctrl+u or Ctrl+f Ctrl+b: a page down / up in the gallery)
| q / Esc | The gallery: the folder you opened from and the folders inside it (on a picture in ~/wallpapers/anime, q shows anime's and night's), with the one you were on picked. Never anything above that folder. Neither closes it: Super+q does

## Privacy and safety (OPSEC)

> OPSEC means not giving away more than you mean to: who you are, where you are, what you use, what you have. Each layer below closes one gap. None is perfect alone; together they make you a much harder target than a default setup.

### kp: passwords in a terminal (Super+Shift+d)

| Opens | Your KeePassXC database (asks for the master password); opening a .kdbx in yazi opens kp on that one, without changing your usual one. Always fully solid (Super+- doesn't make it see-through); the row you're on is a solid bar, bold, with a ▶
| j k / l or Enter / h / / (or Ctrl+f) / g G / q or Esc | Move / open a folder or copy the password / up / search / top, bottom / close kp
| u | Copy the username
| a | Copy the login: the username now; once you paste it, the password is copied in its place. kp hides until you paste the password, then comes back (Super+Shift+d brings it back sooner); the password clears 15 s after it's copied; not pasted within a minute, the username clears and the password isn't copied. Ctrl+a in search, a in an entry's edit view
| e / n / p | Edit an entry / make a new one in the folder you're in (an empty folder is listed too, to add its first) / the password generator (r new, h/l or - + shorter/longer, 1–4 character types, w words)
| Shift+D | Delete the entry you're on (also in its edit view; Ctrl+d in search): Enter deletes it, Esc or q keeps it. It's gone for good, not put in the Recycle Bin. Folders are deleted in KeePassXC
| In an entry (e) | Enter changes the line you're on (Notes opens in your editor; for Password, Enter on its own opens the generator) · s shows or hides the password · y copies it · u the username · a the login · Shift+D deletes it · h, q or Esc back. A field can't be emptied
| Ctrl+o | Open another database: lists every .kdbx in your home folder, up to 5 folders down, not in .cache (j/k move, Enter or l opens, Esc or q stays; nothing to type); the one you pick becomes your usual one. Works at the master password prompt too, any time (Esc there closes kp)
| After copying | kp hides itself until you paste what it copied (Ctrl+v, Ctrl+Shift+v or Shift+Insert, anywhere), then comes back. Once the copy is cleared or you copy something else, pasting no longer brings it back. Super+Shift+d brings it back any time. Copied secrets clear after 15 s
| In search | Enter copies the password, Ctrl+u copies the username, Ctrl+a the login, Ctrl+e edits, Ctrl+d deletes
| A login | Copy the username, paste, copy the password, paste: kp gets out of the way and back by itself
| Super+Shift+d again | Hides it without locking it; once more brings it back
| Why it matters | One strong, different password per site means one leaked site can't open the others. The database is encrypted on disk, so a stolen laptop or backup gives nothing without the master password. Copies are marked 'sensitive' and wiped after 15 s, so they don't linger on the clipboard for another app (or a screen share) to see.
| KeePassXC | Locks itself after 5 minutes idle and when you lock the screen.

### send: files to and from another computer (S and Ctrl+G in yazi)

#### How it works

send copies files from this computer to another one (or from it to here) over SSH, the same secure connection you'd use to log in to it remotely. The copying itself is done by rsync, which only sends what isn't there yet and can pick up where it left off.

- **The other computer only needs its SSH server on.** If you can already ssh or rsync to it, there's nothing to do there. If not, send receive on it turns the SSH server on, lets SSH through its firewall, and prints the send setup line to type on the other computer (one per network: your Wi-Fi, a VM network…).
- **Once, on either computer (optional, but nicer):** send setup user@address gives that computer a short name (laptop, vm…) and saves it in ~/.ssh/config. It also puts your SSH key there, so from then on nothing asks for its password (you type it this one time). That name then works everywhere: ssh laptop, rsync, send. It then sets up the other way too: it asks a name for this computer, saves it in that computer's ~/.ssh/config and lets its key in here, so both can send to each other after one setup.
- **Any number of computers:** run send setup once for each (laptop, a VM, pi…), then pick one by name when you send. You can also skip setup and type user@address:PATH straight in; that works too, but asks for its password every time.
- **Every time after that:** select files in yazi and press S (or send FILE… in a terminal). With more than one computer saved it first lists them (the one you used last on top: j/k move, Enter picks); then it asks where on it, with the path you last used there already filled in, so usually you just press Enter twice. The other computer shows a pop-up when they arrive; clicking it opens that folder.
- **Getting files instead:** in yazi, go to the folder they should land in and press Ctrl+G (or send get in a terminal there). It lists the files on the other computer; pick some and they're copied here.
- **Addresses that change:** routers hand out new addresses now and then. send receive makes a computer answer to a name on your network (like laptop.local), and setup saves that name instead of the address when the other side answers to it, so sending keeps working after a reboot.
- **Where to** is NAME:PATH, like laptop:~/Pictures/ or vm:~/inbox/, or user@192.168.1.20:~/inbox/ for one you haven't named. Pick another computer from the list (or other… to type one), or change the name at the prompt; it remembers the last path for each computer. A path ending in / is a folder: it's made if it isn't there and the files go inside it.
- **If it stops halfway** (the other computer went to sleep, the Wi-Fi dropped), send the same files again. Finished files are skipped and a half-sent one carries on from where it got to.
- **Nothing is deleted or moved:** the files stay here too, and other files on the other computer are left alone. A file there with the same name as one you send is replaced by yours.

#### Reference

| Once, on the computer that receives | send receive: turns its SSH server on (and keeps it on: updates leave it alone from then on), turns on avahi so it answers to NAME.local on your network, lets both through the firewall, and prints the send setup line to use, one per network it's on (your Wi-Fi by name, each VM network)
| Once, on either computer | send setup user@address: asks a short name for that computer (laptop, say) and adds it to ~/.ssh/config, so the name works in ssh, rsync and send; puts your SSH key there (making you one first if you have none; its password, once), makes sure it has rsync, and fills the name in as where to send. Setting up a name again replaces its old address
| The other way | Setup then does the same from there: turns this computer's SSH server on, makes that computer an SSH key if it has none, lets it in here, asks a name for this computer and saves it in that computer's ~/.ssh/config (and as where it sends). It checks that computer can reach this one; if it can't (another network, behind a router), sending there still works and only the way back waits
| Already named | send setup NAME (one from ~/.ssh/config) uses its saved address; send setup user@address NAME names it without asking
| Names, not addresses | At the end setup tries each computer's network name (NAME.local) and, if it answers with the same SSH key, saves that instead of the address, on both sides. A computer set up before this keeps its address: send receive on it, then send setup NAME again
| Its address changed | If the saved address can't be reached, setup says so and asks for the new one (user@address), then saves it under the same name. send receive on that computer shows its address
| Your virtual machines | They reach this computer at their VM network's gateway (usually 192.168.122.1), not at its home-network address; send receive here prints the setup line for each VM network
| If setup stops | "is there, but its SSH server is off": run send receive on it · "its firewall blocks SSH" (it answers ping, but not SSH): run send receive on it · "answered, but the key couldn't be put there": wrong user or password · a computer that doesn't answer at all: after about 15 seconds it asks for the address again
| Sending | S in yazi, or send FILE… in a terminal: with more than one computer saved, a list of them first (the last one used on top; j/k move, Enter picks, q cancels, other… types user@address); then where on it: the computer stays fixed at the start of the line and you edit only the path, filled in with the one last used there. With only one saved it goes straight to where. A folder goes over as the folder itself
| Where to | A path on that computer, like ~/Pictures/ or ~/inbox/. Ending in / it's a folder (made if missing) and the files go into it; without, one file is sent under that name (sending several, it's always a folder). The line works as in your terminal (zsh: vi keys, Ctrl+Backspace…), and Tab completes from the folders and files on that computer just as it does here: the list in your colours, Tab again for the menu, arrows or hjkl to move, Enter picks (only with its key set up, i.e. after send setup). Empty or Ctrl+C cancels. other… asks for user@address first (user@address:PATH fills in the path too)
| Progress | One line for the whole lot: how much is done, the speed and the time left
| Stopped halfway | Send again: it picks up where it left off and skips what's already there unchanged. A pop-up says when it's done or failed
| On the other computer | A pop-up "Received FILE from THIS-COMPUTER → FOLDER"; clicking it opens the folder in yazi. Nothing shows if nobody's logged in there
| Getting files | Ctrl+G in yazi, or send get [NAME] in a terminal: asks which computer (the same list as sending, or last one filled in when only one is saved), then lists its files and folders (not hidden ones; folders end in /). Type to search, Ctrl+J/K move, Tab ticks several (a green ✓), Enter copies them into the folder you're in. A folder comes over as the folder itself; files here with the same name are replaced
| Undo the setup | send forget shows one list with nothing ticked: named computers, other addresses this computer remembers from SSH (connecting there again asks once to trust it), computers allowed to log in here, and this computer's SSH server (with its network name, if send turned that on)
| In that list | Nothing to type: j/k move (▶ and a grey bar on your line), Enter on a line forgets that one and it's done. For several: Space ticks or unticks and goes to the next (green ✓), a ticks all (again: none), the top counts the ticked ones, Enter forgets the ticked ones. q cancels
| Then | A forgotten computer's address and its last path go with it. Your own SSH key stays (GitHub uses it)
| A setup that fails | Nothing is saved: a computer that couldn't be reached (firewall, SSH server off, wrong address or password) is taken out again, so it never shows up when you send. The same goes the other way: if the other computer can't reach this one, it isn't saved there

### VPN with a kill switch (Super+u, vp)

| Super+u | On or off: runs vp in a terminal on tag 9, and you stay on your tag. Off and straight back on: if the last one is still disconnecting, a notification says to try again in a moment. Off before it's connected says so too (VPN off)
| vp / vpn fetch | Start it in the terminal you're in / download the config again
| vpn avoid | The countries (or cities) it never connects to, one per line (~/.config/vpn/avoid): France and Netherlands at first, which leaves the US and Canada. Riseup's servers are in Paris, Amsterdam, Seattle, Miami, New York and Montreal. Takes effect at the next Super+u; vp says how many servers are left
| Padlock | In the bar while it's on: click for where you appear, right-click for a leak test
| Kill switch | Nothing can leave outside the VPN. If it drops, the internet stays blocked until you press Super+u (or Ctrl+C in its window), so you never fall back to your real address without noticing. Your own network (other computers, the router, your VMs) still works
| Fresh VPN config | Super+u and vp connect with the saved config, then quietly fetch a fresh one through the VPN for next time (the certificates last about a month; what it printed is in ~/.cache/vpn-fetch.log). Turning the VPN off stops a fetch still going. If the saved one is missing or runs out within a day, they fetch one first; if that fails and it has run out, the VPN doesn't start (the kill switch would block everything) and a notification says why
| VPN off | The internet works normally with your real address; only while the VPN's on does the kill switch block everything outside it
| DNS | With the VPN on, every name lookup goes to Quad9 through it, so your internet provider can't see which sites you visit
| Why | Sites see the VPN's address, not your home's; your provider sees only scrambled traffic to the VPN
| No password | The part that needs root is /usr/local/lib/vpn-root, allowed by a sudo rule for exactly that. It keeps only plain settings from the config (nothing that runs programs or touches files)
| The first time | (and after its source, ~/.local/lib/vpn-root, changes) Super+u opens a small window that asks your password once to install it; vp asks in the terminal instead

### Browser (Glide)

| Wiped on close | History, downloads list, form data and cache. Cookies stay, but each site gets its own jar, so sites can't follow you from one to another
| Network | HTTPS only, encrypted DNS (Mullvad; a lookup it can't answer goes to the normal DNS rather than failing the page), no prefetching, WebRTC can't leak your real IP
| Looking like everyone else | Sites see US English and UTC as the time zone; the browser's own region (search suggestions) is US and never looked up from your address, and code on pages uses the default monospace font (a custom one is a fingerprint). Canvas, WebGL and the window size are left as they were (protecting canvas broke images)
| No reporting | No telemetry, suggestions, sponsored content or location; strict tracking protection
| Links | Tracking bits stripped from links you copy anywhere (utm, fbclid, gclid, YouTube 'si', Amazon ref …)
| Add-ons | uBlock Origin, Dark Reader and Pywalfox (wallpaper colours) install themselves

### lk: encrypted drives

> lk sets up, mounts and unmounts encrypted (LUKS) drives, like the backup drive. It runs in a terminal and asks for your sudo password, since disk work needs root.

| lk setup (lk s) | Make a drive an encrypted drive that's yours: everything on it is erased, and it ends up as one encrypted partition (ext4), mounted
| Its questions | All asked first: which drive, a name for it, where to mount it (/mnt/hdd unless you change it), and whether to overwrite all of it. Then you type YES and choose its passphrase; the rest runs by itself
| Overwrite all of it | Asked as [Y/n], so Enter says yes (n skips it). Slow (it says about how long): fills the whole drive so nothing that was on it before can be recovered. Ctrl+C stops it, and lk setup can be run again
| lk mount (lk m) | Unlock and mount a drive. A drive lk knows only asks for its passphrase; a new one first asks a name and where to mount it. With several plugged in, you pick one
| lk unmount (lk u) | Unmount and lock it, so you can unplug it. If something is still using it, lk says which programs: close them (or cd out of it in that terminal) and run lk u again
| Never the system's disk | The disks the system runs from (/, /boot, /home, swap…) are never offered
| Where | Drives go on an empty folder under /mnt, /media, /run/media or your home folder
| Remembered | ~/.config/lk/drives, a line per drive: its ID, name and mount point. Edit a line to rename or move one; delete it to be asked again
| If it stops | Stopped partway (an error, Ctrl+C), the drive it opened is unmounted and locked again
| Pulled out while mounted | The drive is left stuck (its folder gives I/O errors and lk m says something is already mounted there). lk m and lk u notice it, clear what it left behind and carry on: lk m then mounts it again as usual
| Why | A lost or stolen drive gives nothing away without its passphrase
| The backup drive | Set it up with lk setup at /mnt/hdd

### backup: copies of your files on the backup drive

> backup keeps encrypted backups of your home folder on the backup drive, and copies any files or folders somewhere as they are. It runs in a terminal; if the drive isn't mounted, it offers to mount it (lk mount).

| backup | Back up the folders you usually pick (your whole home folder, less caches, Downloads, Videos and private, unless you change it) as one encrypted file on the drive. A list shows first: Enter backs up what's ticked
| The first time | It makes the backup key and asks you to choose its passphrase: restoring needs it (and only it). A copy of the key goes on the drive, so another computer can restore from it
| backup --pick | Choose what's backed up by default (Ctrl+S in the list saves it too)
| Kept | The newest backup of each day for 7 days, of each week for 4 weeks and of each month for 6 months. One-offs (not your usual folders): the newest 3
| backup list | The backups on the drive, oldest first, with their sizes
| backup restore [FILE] [DIR] | Unpack the newest backup (or FILE) into ~/restore-DATE (or DIR), after the key's passphrase. Nothing of yours is overwritten
| backup PATH… to DEST | Copy files or folders into DEST as they are (not encrypted): backup ~/backups to /mnt/hdd makes /mnt/hdd/backups. The "to" can be left out. Run again, it copies only what's new or changed, and never takes anything out of DEST
| Where | ~/.config/backup/config: BACKUP_DEST, /mnt/hdd/backup unless you change it. BACKUP_TO=HOST:FOLDER sends to another computer over SSH instead, as plain files kept in step with yours
| Before unplugging | lk u

### blank: wipe a drive like new

> blank erases a drive (a USB stick, an external disk) and makes it like new: one partition with the filesystem you pick, or nothing at all, ready to flash an ISO onto. It runs in a terminal and asks for your sudo password. For an encrypted drive, use lk setup instead (it wipes the drive itself).

| blank | Pick the drive (j/k move, Enter picks, q cancels), then what to make it, then its name (what you see when you plug it in; USB unless you change it)
| exFAT | Works on Windows, Mac, Linux, TVs and cameras, files of any size: best for most USBs
| FAT32 | Works on everything, even old devices and car stereos, but no file over 4 GB
| ext4 | Linux only. The drive is yours (no sudo needed to write to it)
| NTFS | Windows; a Mac can only read it
| blank | Wiped with no partition at all, ready for dd: sudo dd if=FILE.iso of=/dev/sdX bs=4M oflag=direct conv=fsync status=progress (dd overwrites everything anyway, so this is only for starting clean)
| Overwrite all of it | Asked as [Y/n], so Enter says yes (n skips it). Slow (it says about how long): zeros over the whole drive so nothing that was on it can be recovered
| Then | One YES, and the rest runs by itself: whatever on the drive is mounted, used as swap or unlocked is unmounted and locked, every old partition and signature (an ISO's too) is wiped, then it's partitioned (MBR under 2 TiB, for TVs and old computers; GPT above) and formatted
| Never the system's disk | The disks the system runs from (/, /boot, /home, swap…) are never offered
| An lk drive | Erasing one also takes it out of ~/.config/lk/drives
| If it stops | Before YES, nothing has changed. After, the drive may be left half-made: run blank again

### SSH key

| What | ~/.ssh/id_ed25519, protected by a passphrase; the agent asks for it once per login
| Why | Logs you in to GitHub and servers without a password that could be phished or guessed; the private key never leaves the computer, and the passphrase protects it if the file is ever copied
| Use | cat ~/.ssh/id_ed25519.pub → paste into GitHub › Settings › SSH keys · ssh -T git@github.com tests it

### Other quiet protections

| Lock screen | Locks by itself after 45 minutes idle. Pauses media, mutes, wipes the clipboard, closes kp and locks KeePassXC
| Kernel | Programs can't read each other's memory (ptrace), kernel addresses are hidden from normal programs, and unsafe kernel features (unprivileged BPF, kexec, line-discipline loading) are off. These are the doors most local attacks use. Kernel messages are hidden too, unless this system was set up to let you read them (/etc/sysctl.d/dmesg.conf)
| Network | No TCP timestamps: sites can't use them to guess how long your computer has been on or to tell machines apart
| Nothing online by itself | No NetworkManager online check, no nightly news fetch, no weekly keyring refresh (update does it): after a boot, nothing reaches the internet until you open something
| No SSH server | Nothing can log in to this computer over the network unless send receive has turned the SSH server on (send needs it); once on, it stays on
| Firewall | Nothing can connect in unless this computer started it (replies still get through). Let in: ping, getting an address, your VMs, Syncthing, and SSH and NAME.local, which only answer once send receive has turned them on
| Nothing left on disk | No crash dumps (they can hold passwords from memory), system logs in RAM only, swap only in compressed RAM: a swap partition on this system's disk (the one / is on; other attached disks are left alone) is wiped and retyped so it never comes on at boot, once /etc/fstab no longer uses it, since what's swapped out could be passwords

## Tools and scripts

| record-screen [-r] [-m] [-n] [-s] [-p] | Record the screen (region, microphone, no sound, notifications showing, pause). Saved to ~/Videos. The same key again (Super+F1) stops it
| clicker | Auto-clicker: clicker -i 50 -b right -j 10 -n 100 (interval, button, random jitter, count); clicker speed (Super+Shift+F6) sets it. Running a command again stops it; holding Super pauses it. clicker check says what's stopping it, if anything
| clicker macros | clicker record NAME, clicker play NAME -r 5 (or -l to loop, -t 600 for ten minutes) -s 2, clicker pick (choose one, Super+F11), clicker list / edit. Macros are plain text you can edit; a key held down plays back held
| wallpaper [IMAGE or FOLDER] | Random day/night wallpaper (as Super+b) / set that picture, or a random one from that folder, and recolour the whole desktop. wallpaper dir: the folder in use (wallpaper dir pick, or wallpaper dir set DIR session|always, changes it); wallpaper warm: work out colours ahead of time
| ~/.config/mango/scripts/guide build | Rebuild System Guide.pdf from its source (~/Documents/.system-guide/guide.md) after editing it; Super+F9 opens the PDF (~/Documents/System Guide.pdf)
| settimes | Edit times.conf (night wallpapers, red screen and dimming) and apply it. A value it can't read uses its default (a notification says which), and it offers to reopen the editor
| apphide NAME / -u / -l | Hide an app from the launcher / show it again / list hidden. Kept in your dotfiles

### Night mode: red screen and dimming

| night-mode | At night the screen goes 40% red and as dim as it goes: from dim_start (01:00) to night_end (05:00). At dim_end (06:00) the brightness goes back to full. The dim timer runs it at those times; settimes changes them
| After a boot | Never red or dim straight after turning the computer on, even at night: only once dim_start comes round with it on (waking from sleep counts). Red you turned on by hand is gone after a reboot or shutdown too
| Super+Right / Super+Left | Redder / less red, any time of day (until night_end and dim_end turn it off), 10% a press (a notification shows the level); all the way down turns it off. dim_start always starts it at 40% again
| night-mode off | Normal colours now (red again at the next dim_start)
| nightred | The red itself: a small program that tints the screen, started and stopped by night-mode. It can't if another program already controls the screen's colours (like wlsunset)

## Keeping the system up to date

> Everything outside your home folder is set up by sys-setup, so a new machine ends up the same as this one.

| update | Full update, start to finish without stopping; asks for your password once, at the start
| What update does | Arch news since your last update (shown, without stopping), the keys that sign Arch's packages (once a week: about 30 seconds, and it says so), then system packages, then AUR updates if there are any (straight through, no questions), sys-setup, flatpaks, nvim and yazi plugins, cleanup. Last of all, a Flatpak section: each app that updated (old version → new), anything installed or removed, how many runtimes changed, or that nothing did
| Its checks | Missing libraries in mango or quickshell (it says what to run to rebuild), a new kernel (→ reboot), a mango that doesn't accept your config. An AUR program that a library update broke (sioyek after every mupdf update: "libmupdf.so… cannot open shared object file") is built again against the new library, so it starts again without you doing anything.
| sys-setup | Puts the system side in place. Safe to re-run; runs on every update (on a new machine, run it once yourself)
| What it sets up | Needed packages (and yt-dlp-git, pywal16), clicker access, nvim plugins, login screen settings, hidden apps, dark GTK apps and virt-manager's settings (~/.config/dconf/dots.ini, loaded whenever it changes)
| What it locks down | The firewall, hardening, no online checks, the SSH server off unless send receive turned it on, the ssh agent, RAM-only logs, zram swap, the clock kept right from a time server
| Free software only | sys-setup keeps out what isn't free software: no 7-Zip (its RAR code isn't free; libarchive does archives instead) and no Fraunhofer AAC library (only Bluetooth AAC headphone sound used it; the free codecs remain), and updates never bring them back. The exception you chose: hardware firmware
| update's clean-up | After a system update that went through, it frees space: orphan packages, package caches, old logs, app and browser caches, unused caches, bin. Then tidies: Python package downloads (uv), caches of apps no longer installed, and unused container images
| ud | Publish folders in ~/github to GitHub: U on the selected folders in yazi, ud alone lists them (j/k move, Space ticks, a ticks all, u changes your GitHub username), or ud NAME…; it publishes to the GitHub username you typed (the very first time, ud starts by asking it; never guessed); each one fresh commit with no history, secret scan first (if gitleaks finds something it shows it and asks before pushing), the SSH passphrase asked once. The repo has to exist on GitHub already (github.com/new)

## Default apps

| PDF and e-books (EPUB, MOBI, FB2, CBZ, XPS) | sioyek
| Text and code | Neovim in kitty
| Images | swayimg
| Video / audio | mpv / small mpv audio window
| Web links, HTML | Glide
| Folders | yazi
| Password databases | kp from yazi (KeePassXC from other apps, or as yazi's second choice)

### Other apps

| btop (Super+Shift+r) | System monitor with vim keys and wallpaper colours (changes made in its menu last until it closes)
| fastfetch (f) | System summary
| virt-manager (Super+v) | Your virtual machines: see the keys under Desktop (Super+p, Super+a, Super+n, Super+Shift+w)
