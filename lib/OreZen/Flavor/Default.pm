package OreZen::Flavor::Default;

use strict;
use warnings;
use parent 'OreZen::Flavor';

1;
__DATA__
@@ tmpl/index.mt
? my $title = shift;
? my $content = shift;
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title><?= $title ?></title>
<link rel="stylesheet" href="static/css/style.css" />
<link rel="stylesheet" href="static/css/pretty.css" />
<link rel="stylesheet" href="static/css/custom.css" />
<meta name="viewport" content="width=devide-width,initial-scale=0.8,user-scalable=no" />
</head>
<body>
<?= $content ?>
<div id="dummy"></div>
<div id="date"></div>
<div id="page"></div>
<div id="help">
<p>j or &rarr;: next</p>
<p>k or &larr;: prev</p>
<p>h or &uarr;: list</p>
<p>l or &darr;: return</p>
<p>o or &crarr;: open</p>
<p>? or /: toggle this help</p>
</div>
<script type="text/javascript" src="static/js/slide.js"></script>
<script type="text/javascript" src="http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.js"></script>
<script type="text/javascript" src="static/js/prettify.js"></script>
</body>
<html>
@@ static/js/prettify.js
(function() {
    if (typeof prettyPrint === 'function') {
        var pre = document.getElementsByTagName('pre');
        for (var n = pre.length; n --> 0;) {
            pre[n].className = (pre[n].className || '').split(/[ \t\r\n]+/).concat('prettyprint').join(' ')
        }
        prettyPrint();
    }
})();
@@ static/js/slide.js
(function() {
var width = 0;
var listView = false;
var imgTags = document.getElementsByTagName('img');
var fontTimer = setInterval(function(){
    if (!listView && width != document.documentElement.clientWidth) {
        width = document.documentElement.clientWidth;
        document.body.style.fontSize = width / 5 + '%';
        for (var i = 0, l = imgTags.length; i < l; i++) {
            imgTags[i].style.maxWidth = width * 0.8 + 'px';
        }
    }
}, 100);
var startTime = (new Date()).getTime();
var dateTimer = setInterval(function() {
    var elasped = Math.floor(((new Date()).getTime() - startTime) / 1000);
    var seconds = elasped % 60;
    var minutes = Math.floor(elasped / 60);
    if (seconds.toString().length == 1) {
      seconds = '0' + seconds;
    }
    if (minutes.toString().length == 1) {
      minutes = '0' + minutes;
    }
    document.getElementById('date').innerHTML = minutes + ':' + seconds;
}, 100);

var slides = [];
var stash  = {};
var NC = 'next';
var PC = 'prev';
var VC = 'view';
var LC = 'list';
var articles = document.querySelectorAll('body > section');
for (var i = 0, l = articles.length; i < l; i++) {
    var section = articles[i];
    section.id = i + 1;
    var name = section.className || '';
    addClass(section, NC);
    slides.push(section);
}

var current = 0;
var count = slides.length;

var KEYBORD = {
    Left  : 37,
    Up    : 38,
    Right : 39,
    Down  : 40,
    Enter : 13,
    H     : 72,
    J     : 74,
    K     : 75,
    L     : 76,
    O     : 79,
    Help  : 191, // ? or /
};
document.onkeydown = function(e) {
    if (!e) {
        e = window.event;
    }
    var key = e.keyCode;
    console.log(key);
    if (key === KEYBORD.J || key === KEYBORD.Right) {
        listView === false ? next() : nextlist();
    }
    else if (key === KEYBORD.K || key === KEYBORD.Left) {
        listView === false ? prev() : prevlist();
    }
    else if ((key === KEYBORD.H || key === KEYBORD.Up) && listView === false) {
        for (var i = 0, l = slides.length; i < l; i++) {
            stash[i] = {
                "class": slides[i].className,
                "click": (function(page) {
                    return function() {
                        location.hash = page + 1;
                        location.reload();
                    }
                })(i),
                "focused": i === current ? true : false,
            };
            replaceClass(slides[i], [NC, PC, VC, 'focus'], 'invisible');
        }
        document.getElementById('page').style.display = 'none';
        document.getElementById('date').style.display = 'none';
        setTimeout(function() {
            width = null;
            document.body.style.fontSize = '3%';
            for (var i = 0, l = imgTags.length; i < l; i++) {
                imgTags[i].style.maxWidth = width * 0.15 * 0.8 + 'px';
            }
            listView = true;
            for (var i = 0, l = slides.length; i < l; i++) {
                slides[i].addEventListener('click', stash[i].click, false);
                replaceClass(slides[i], ['invisible'], LC);
                if (stash[i].focused) {
                    addClass(slides[i], 'focus');
                }
            }
        }, 500);
    }
    else if ((key === KEYBORD.L || key === KEYBORD.Down) && listView === true) {
        for (var i = 0, l = slides.length; i < l; i++) {
            replaceClass(slides[i], [LC, 'focus'], 'invisible');
            replaceClass(slides[i], ['focus'], 'up');
        }
        listView = false;
        setTimeout(function() {
            for (var i = 0, l = slides.length; i < l; i++) {
                slides[i].removeEventListener('click', stash[i].click, false);
                var className = stash[i].class;
                replaceClass(slides[i], ['invisible', 'up'], className);
            }
            document.getElementById('page').style.display = null;
            document.getElementById('date').style.display = null;
        }, 500);
    }
    else if ((key === KEYBORD.O || key === KEYBORD.Enter) && listView === true) {
        listView = false;
        stash[current].click();
    }
    else if (key === KEYBORD.Help) {
        toggleHelp();
    }
};

function gap(a, b) {
    return a > b ? a - b : b - a;
}

(function() {
    var xStart = 0, xEnd = 0, yStart = 0, yEnd = 0;
    var center = document.width / 2;
    document.addEventListener('touchstart', function(e) {
        xStart = xEnd = e.touches[0].pageX;
        yStart = yEnd = e.touches[0].pageY;
    }, false);

    document.addEventListener('touchmove', function(e) {
        xEnd = e.touches[0].pageX;
        yEnd = e.touches[0].pageY;
    }, false);

    document.addEventListener('touchend', function(e) {
        if (!(gap(yStart, yEnd) > 100)) {
            if (xStart == xEnd) {
                if (xStart > center) {
                    next();
                }
                else {
                    prev();
                }
            }
            else if (xStart > xEnd) {
                next();
            }
            else if (xStart < xEnd) {
                prev();
            }
        }

        xStart = xEnd = yStart = yEnd = 0;
    }, false);
})();

setTimeout(function(){
    var matched;
    document.getElementById('page').style.display = 'block';
    document.getElementById('date').style.display = 'block';
    if (matched = location.hash.match(/^#(\d+)$/)){
        current = +matched[1] - 1;
        for (var i = 0; i < current && slides[i]; i++){
            replaceClass(slides[i], [NC, VC], PC);
        }
        replaceClass(slides[current], [PC, NC], VC);
    }
    else {
        replaceClass(slides[0], [PC, NC], VC);
    }
}, 500);

/* utility functions */
function next() {
    if (!slides[current+1]) return;
    replaceClass(slides[current++], [NC, VC], PC);
    replaceClass(slides[current], [PC, NC], VC);
    location.hash = current + 1;
}
function prev() {
    if (!slides[current-1]) return;
    replaceClass(slides[current--], [PC, VC], NC);
    replaceClass(slides[current], [PC, NC], VC);
    location.hash = current + 1;
}
function nextlist() {
    if (!slides[current+1]) return;
    removeClass(slides[current], 'focus');
    stash[current++].class = PC;
    addClass(slides[current], 'focus');
    stash[current].class = VC;
    location.hash = current + 1;
}
function prevlist() {
    if (!slides[current-1]) return;
    removeClass(slides[current], 'focus');
    stash[current--].class = NC;
    addClass(slides[current], 'focus');
    stash[current].class = VC;
    location.hash = current + 1;
}
function removeClass(elem, targets) {
    if (typeof targets !== "object") { // non-array
        targets = [targets];
    }
    var targetMap = {};
    for (var i = 0, l = targets.length; i < l; i++) {
        targetMap[targets[i]] = 1;
    }

    var classes = elem.className.split(/ /);
    var result = [];
    for (var i = 0, l = classes.length; i < l; i++) {
        var name = classes[i];
        if (!targetMap[name]) {
            result.push(name);
        }
    }
    elem.className = result.join(' ');
}
function addClass(elem, target) {
    if (elem.className !== '') {
        elem.className += ' ' + target;
    }
    else {
        elem.className = target;
    }
}
function replaceClass(elem, from, to) {
    removeClass(elem, from);
    addClass(elem, to);
}

var helpElem = document.getElementById('help');
function toggleHelp() {
    helpElem.style.display = (helpElem.style.display !== 'block') ? 'block' : 'none';
}

var pageElem = document.getElementById('page');
var countTimer = setInterval(function(){
    pageElem.innerHTML = current + 1;
}, 100);

})();
@@ static/css/style.css

/* reset styles */
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,form,fieldset,input,textarea,p,blockquote,th,td,article,section {
    padding:0;
    margin:0;
}

body {
    background-color: #5b5;
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
}

body > section {
    position: absolute;
    top: 3%;
    bottom: 3%;
    left: 1%;
    background: rgba(48,48,48,0.3);
    color: #fff;
    text-shadow: 3px 3px 5px #000;
    letter-spacing: 0.15em;
    padding: 0%;
    height: 0%;
    overflow: auto;
    width: 98%;
/*    border-radius: 20px; */
    opacity: 0;
}

h1, h2, h3 {
    text-shadow: 3px 3px 5px #000;
}

h1 {
    text-align: center;
    font-size: 150%;
    border-bottom: 2px dashed #fff;
    padding-left: 0.2em;
}

h2 {
    margin: 0.3em;
    font-size: 120%;
}

h3 {
    margin: 0.4em;
    font-size: 100%;
}

p {
    margin: 1em;
    font-size: 80%;
}

ul {
    list-style-type: disc;
    margin-left: 2em;
    margin-top: 0.2em;
    margin-bottom: 0.2em;
}

ol {
    list-style-type: decimal;
    margin-left: 2em;
    margin-top: 0.2em;
    margin-bottom: 0.2em;
}

section > ul, section > ol {
    font-size: 80%;
    margin-top: 0.5em;
    margin-bottom: 0.5em;
}

#help {
    background-color: #000;
    color: #fff;
    font-size: 50%;
    position: absolute;
    right: 3%;
    bottom: 3%;
    opacity: 0.7;
    font-weight: bold;
    display: none;
}

#help p {
    font-family: monospace;
    opacity: 1;
}

#page {
    color: #fff;
    position: absolute;
    font-size: 60%;
    right: 2.5%;
    bottom: 1%;
    font-weight: bold;
    display: block;
    text-shadow: 3px 3px 5px #000;
    opacity: 0.7;
}

#date {
    color: #fff;
    position: absolute;
    font-size: 40%;
    left: 2%;
    bottom: 1%;
    font-weight: bold;
    display: block;
    text-shadow: 3px 3px 5px #000;
    opacity: 0.7;
}

.next {
    top: -100%;
    height: 95%;
}

.prev {
    bottom: -100%;
    height: 95%;
}

.view {
    height: 95%;
    opacity: 1;
}

.invisible {
    opacity: 0;
}

.up {
    top: -100%;
    height: 95%;
}

.list {
    width: 15%;
    height: 20%;
    margin: 1.3%;
    left: 0%;
    top: 0%;
    bottom: 0%;
    float: left;
    opacity: 0.5;
    border-radius: 20px;
    position: relative;
    border: 1px solid #000;
}
.list:hover {
    opacity: 1;
    border: 1px solid #3f3;
}
.focus {
    opacity: 1;
    border: 1px solid #3f3;
}

.center {
    text-align: center;
}

.align-center {
    position: relative;
    top: 30%;
}

a {
    text-decoration: underline;
}
a:link {
    color: #fa5;
}
a:visited  {
    color: #fa5;
}

pre {
    margin: 1em;
    padding: 0.5em !important;
    font-size: 45%;
    border: 2px solid #fff;
    color: #000;
    background-color: #fff;
    font-family: 'Monaco' monospace;
    text-shadow: none;
    word-wrap: break-word;
}

table {
    margin: 1em;
    padding: 0.5em;
    border: 2px solid #222;
    border-collapse: collapse;
    border-spacing: 0;
    color: #000;
    width: 94%;
    font-size: 80%;
}

th {
    padding: 5px;
    border: #222 solid;
    border-width: 0 0 2px 2px;
    background: #bbb;
    font-weight: bold;
    text-align: center;
}

td {
    padding: 5px;
    border: 1px #222 solid;
    border-width: 0 0 2px 2px;
    background: #fff;
    text-align: center;
}

code {
    border-radius: 10px;
    background-color: #fff;
    padding: 5px;
    color: #33e;
    text-shadow: 3px 3px 5px #999;
    font-weight: bold;
}

#dummy {
    clear: left;
    height: 1px;
}

@@ static/css/pretty.css
/* pretty */
.str{color:#080}.kwd{color:#008}.com{color:#800}.typ{color:#606}.lit{color:#066}.pun{color:#660}.pln{color:#000}.tag{color:#008}.atn{color:#606}.atv{color:#080}.dec{color:#606}pre.prettyprint{padding:2px;border:1px solid #888}ol.linenums{margin-top:0;margin-bottom:0}li.L0,li.L1,li.L2,li.L3,li.L5,li.L6,li.L7,li.L8{list-style:none}li.L1,li.L3,li.L5,li.L7,li.L9{background:#eee}@media print{.str{color:#060}.kwd{color:#006;font-weight:bold}.com{color:#600;font-style:italic}.typ{color:#404;font-weight:bold}.lit{color:#044}.pun{color:#440}.pln{color:#000}.tag{color:#006;font-weight:bold}.atn{color:#404}.atv{color:#060}}

@@ static/css/custom.css
/* your custom style */
