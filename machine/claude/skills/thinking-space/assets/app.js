/* ============================================================
   Thinking Space — shared behavior
   theme toggle · reading progress · TOC scrollspy · hub render
   No fetch / no modules → works when opened via file://
   ============================================================ */
(function () {
  "use strict";

  /* ---------- theme ---------- */
  var root = document.documentElement;
  var KEY = "ts-theme";
  function applyTheme(t) {
    root.setAttribute("data-theme", t);
    var btn = document.querySelector(".theme-toggle");
    if (btn) btn.textContent = t === "dark" ? "☀" : "☾";
  }
  var saved = null;
  try { saved = localStorage.getItem(KEY); } catch (e) {}
  if (!saved) {
    saved = (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) ? "dark" : "light";
  }
  applyTheme(saved);

  function initToggle() {
    var btn = document.querySelector(".theme-toggle");
    if (!btn) return;
    applyTheme(root.getAttribute("data-theme") || "light");
    btn.addEventListener("click", function () {
      var next = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
      applyTheme(next);
      try { localStorage.setItem(KEY, next); } catch (e) {}
    });
  }

  /* ---------- reading progress ---------- */
  function initProgress() {
    var bar = document.querySelector(".progress");
    if (!bar) return;
    function update() {
      var h = document.documentElement;
      var max = h.scrollHeight - h.clientHeight;
      var pct = max > 0 ? (h.scrollTop || window.pageYOffset) / max * 100 : 0;
      bar.style.width = pct.toFixed(1) + "%";
    }
    window.addEventListener("scroll", update, { passive: true });
    window.addEventListener("resize", update);
    update();
  }

  /* ---------- TOC scrollspy ---------- */
  function initToc() {
    var links = Array.prototype.slice.call(document.querySelectorAll(".toc a[href^='#']"));
    if (!links.length) return;
    var map = {};
    var targets = [];
    links.forEach(function (a) {
      var id = a.getAttribute("href").slice(1);
      var el = document.getElementById(id);
      if (el) { map[id] = a; targets.push(el); }
    });
    if (!("IntersectionObserver" in window)) return;
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (en) {
        if (en.isIntersecting) {
          links.forEach(function (l) { l.classList.remove("is-active"); });
          var a = map[en.target.id];
          if (a) a.classList.add("is-active");
        }
      });
    }, { rootMargin: "-20% 0px -70% 0px", threshold: 0 });
    targets.forEach(function (t) { io.observe(t); });
  }

  /* ---------- hub: render session cards ---------- */
  function verdictBadge(v) {
    var cls = v.kind === "kill" ? "vbadge--kill" : v.kind === "go" ? "vbadge--go" : v.kind === "warn" ? "vbadge--warn" : "vbadge--neutral";
    return '<span class="vbadge ' + cls + '"><span class="tag">' + v.tag + '</span>' + v.label + "</span>";
  }
  function renderHub() {
    var mount = document.getElementById("session-list");
    if (!mount || !window.THINKING_SESSIONS) return;
    var data = window.THINKING_SESSIONS.slice().sort(function (a, b) {
      return a.date < b.date ? 1 : a.date > b.date ? -1 : 0;
    });

    // tag bar
    var allTags = {};
    data.forEach(function (s) { (s.tags || []).forEach(function (t) { allTags[t] = 1; }); });
    var tagbar = document.getElementById("tagbar");
    var activeTag = null;
    if (tagbar) {
      Object.keys(allTags).sort().forEach(function (t) {
        var b = document.createElement("button");
        b.className = "tagbtn"; b.textContent = t; b.dataset.tag = t;
        tagbar.appendChild(b);
      });
      tagbar.addEventListener("click", function (e) {
        var b = e.target.closest(".tagbtn"); if (!b) return;
        if (activeTag === b.dataset.tag) { activeTag = null; b.classList.remove("is-active"); }
        else {
          activeTag = b.dataset.tag;
          tagbar.querySelectorAll(".tagbtn").forEach(function (x) { x.classList.remove("is-active"); });
          b.classList.add("is-active");
        }
        draw();
      });
    }

    var input = document.getElementById("search-input");
    if (input) input.addEventListener("input", draw);

    function draw() {
      var q = (input && input.value || "").trim().toLowerCase();
      var rows = data.filter(function (s) {
        if (activeTag && (s.tags || []).indexOf(activeTag) === -1) return false;
        if (!q) return true;
        var hay = (s.title + " " + s.summary + " " + (s.tags || []).join(" ")).toLowerCase();
        return hay.indexOf(q) !== -1;
      });
      if (!rows.length) { mount.innerHTML = '<div class="empty">該当するセッションがありません。</div>'; return; }
      mount.innerHTML = rows.map(function (s) {
        var tags = (s.tags || []).map(function (t) { return '<span class="chip">' + t + "</span>"; }).join("");
        var verds = (s.verdicts || []).map(verdictBadge).join("");
        return '<a class="scard" href="' + s.href + '">' +
          '<div class="scard__top"><span class="scard__date">' + s.date + "</span></div>" +
          "<h2>" + s.title + "</h2>" +
          "<p>" + s.summary + "</p>" +
          (verds ? '<div class="scard__verdicts">' + verds + "</div>" : "") +
          '<div class="scard__tags">' + tags + "</div>" +
          "</a>";
      }).join("");
    }
    draw();
  }

  /* ---------- glossary term tooltips (tap on touch devices) ---------- */
  function initTerms() {
    var terms = document.querySelectorAll(".term");
    if (!terms.length) return;
    terms.forEach(function (t) {
      if (!t.hasAttribute("tabindex")) t.setAttribute("tabindex", "0");
      t.addEventListener("click", function (e) {
        e.stopPropagation();
        var wasOpen = t.classList.contains("is-open");
        document.querySelectorAll(".term.is-open").forEach(function (o) { o.classList.remove("is-open"); });
        if (!wasOpen) t.classList.add("is-open");
      });
      t.addEventListener("keydown", function (e) {
        if (e.key === "Enter" || e.key === " ") { e.preventDefault(); t.click(); }
        if (e.key === "Escape") t.classList.remove("is-open");
      });
    });
    document.addEventListener("click", function () {
      document.querySelectorAll(".term.is-open").forEach(function (o) { o.classList.remove("is-open"); });
    });
  }

  /* ---------- boot ---------- */
  function boot() { initToggle(); initProgress(); initToc(); initTerms(); renderHub(); }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
})();
