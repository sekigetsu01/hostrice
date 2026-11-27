.pragma library

// The calendar's date helpers: day and month names, ISO dates (2026-11-27), and the 6 weeks of days in a
// month's grid.
var DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
var MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

function pad(n) {
    return (n < 10 ? "0" : "") + n;
}

function iso(d) {
    return d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate());
}

function fromIso(s) {
    const m = /^(\d{4})-(\d\d)-(\d\d)/.exec(s || "");
    return m ? new Date(+m[1], m[2] - 1, +m[3]) : null;
}

function addDays(d, n) {
    return new Date(d.getFullYear(), d.getMonth(), d.getDate() + n);
}

function wd(d) {
    return (d.getDay() + 6) % 7;
}

function longDate(d) {
    return DAYS[wd(d)] + " " + d.getDate() + " " + MONTHS[d.getMonth()] + " " + d.getFullYear();
}

function monthTitle(y, m) {
    return MONTHS[m] + " " + y;
}

function cells(y, m) {
    const first = new Date(y, m, 1), start = addDays(first, -wd(first)), out = [];
    for (let i = 0; i < 42; i++) {
        const d = addDays(start, i);
        out.push({ iso: iso(d), day: d.getDate(), inMonth: d.getMonth() === m });
    }
    return out;
}
