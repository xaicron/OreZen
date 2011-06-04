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
</head>
<body>
<?= $content ?>
<div id="page"></div>
<div id="help">
<p>j or &rarr;: next</p>
<p>k or &larr;: prev</p>
<p>h or &uarr;: list</p>
<p>l or &darr;: return</p>
<p>o or &crarr;: open</p>
<p>? or /: toggle this help</p>
</div>
<script type="text/javascript" src="http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.js"></script>
<script type="text/javascript" src="static/js/prettify.js"></script>
<script type="text/javascript" src="static/js/slide.js"></script>
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
var fontTimmer = setInterval(function(){
    if (!listView && width != document.documentElement.clientWidth) {
        width = document.documentElement.clientWidth;
        document.body.style.fontSize = width / 5 + '%';
    }
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
    if ((key === KEYBORD.J || key === KEYBORD.Right) && slides[current+1]) {
        listView === false ? next() : nextlist();
    }
    else if ((key === KEYBORD.K || key === KEYBORD.Left) && slides[current-1]) {
        listView === false ? prev() : prevlist();
    }
    else if ((key === KEYBORD.H || key === KEYBORD.Up) && listView === false) {
        for (var i = 0, l = slides.length; i < l; i++) {
            stash[i] = {
                "class": slides[i].className,
                "click": (function(page) {
                    return function() {
                        location.hash = page;
                        location.reload();
                    }
                })(i),
                "focused": i === current ? true : false,
            };
            replaceClass(slides[i], [NC, PC, VC, 'focus'], 'invisible');
        }
        setTimeout(function() {
            width = 15;
            document.body.style.fontSize = width / 5 + '%';
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

setTimeout(function(){
    var matched;
    if (matched = location.hash.match(/^#(\d+)$/)){
        current = +matched[1];
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
    replaceClass(slides[current++], [NC, VC], PC);
    replaceClass(slides[current], [PC, NC], VC);
    location.hash = current;
}
function prev() {
    replaceClass(slides[current--], [PC, VC], NC);
    replaceClass(slides[current], [PC, NC], VC);
    location.hash = current;
}
function nextlist() {
    removeClass(slides[current++], 'focus');
    addClass(slides[current], 'focus');
    location.hash = current;
}
function prevlist() {
    removeClass(slides[current--], 'focus');
    addClass(slides[current], 'focus');
    location.hash = current;
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
    helpElem.style.display = (helpElem.style.display === 'none') ? 'block' : 'none';
}

var pageElem = document.getElementById('page');
var countTimer = setInterval(function(){
    pageElem.innerHTML = current + 1 + '/' + count;
}, 100);

})();
@@ static/css/style.css
/* reset styles */
body, div, dl, dt, dd, h1, h2, h3, h4, h5, h6, pre, form, fieldset, input, textarea, p, blockquote, th, td, article { 
    margin:0;
    padding:0;
    font-size-adjust: 0.5;
}

body {
    background-color: #000;
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    overflow:hidden;
}

body > section {
    position: absolute;
    top: 5%;
    bottom: 5%;
    left: 5%;
    background: #333;
    color: #fff;
    text-shadow: rgba(0,0,0,0.1) 2px 2px;
    letter-spacing: 0.15em;
    padding: 1%;
    height: 0%;
    overflow: auto;
    width: 88%;
    border-radius: 20px;
    opacity: 0;
}

h1, h2, h3 {
    text-shadow: 3px 3px 5px #000;
}

h1 {
    font-size: 150%;
    border-bottom: 2px dashed #fff;
}

h2 {
    font-size: 120%;
}

h3 {
    font-size: 100%;
}

p {
    margin: 1em;
    font-size: 80%;
}

ul {
    list-style-type: disc;
    font-size: 80%;
}

ol {
    list-style-type: decimal;
    font-size: 80%;
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
    font-size: 80%;
    right: 6%;
    bottom: 3%;
    font-weight: bold;
    display: block;
    text-shadow: 3px 3px 5px #000;
    opacity: 0.7;
}

.next {
    top: -100%;
    height: 88%;
    -moz-transition: all 0.5s ease-in-out;
    -webkit-transition: all 0.5s ease-in-out;
    -o-transition: all 0.5s ease-in-out;
    -ms-transition: all 0.5s ease-in-out;
    transition: all 0.5s ease-in-out;
}

.prev {
    bottom: -100%;
    height: 88%;
    -moz-transition: all 0.5s ease-in-out;
    -webkit-transition: all 0.5s ease-in-out;
    -o-transition: all 0.5s ease-in-out;
    -ms-transition: all 0.5s ease-in-out;
    transition: all 0.5s ease-in-out;
}

.view {
    height: 88%;
    opacity: 1;
    -moz-transition: all 0.5s ease-in-out;
    -webkit-transition: all 0.5s ease-in-out;
    -o-transition: all 0.5s ease-in-out;
    -ms-transition: all 0.5s ease-in-out;
    transition: all 0.5s ease-in-out;
}

.invisible {
    opacity: 0;
}

.up {
    top: -100%;
    height: 88%;
}

.list {
    width: 15%;
    height: 20%;
    margin: 1.5%;
    left: 0%;
    top: 0%;
    bottom: 0%;
    float: left;
    opacity: 0.5;
    border-radius: 20px;
    position: relative;
    border: 1px solid #000;
    overflow: hidden;
    -moz-transition: opacity 0.3s ease-in-out;
    -webkit-transition: opacity 0.3s ease-in-out;
    -o-transition: opacity 0.3s ease-in-out;
    -ms-transition: opacity 0.3s ease-in-out;
    transition: opacity 0.3s ease-in-out;
}
.list:hover {
    opacity: 1;
    border: 1px solid #3f3;
}
.focus {
    opacity: 1;
    border: 1px solid #3f3;
}

a {
    text-decoration: none;
}
a:link {
    color: #0f0;
}
a:visited  {
    color: #0f0;
}

pre {
    margin: 1em;
    padding: 0.5em;
    font-size: 80%;
    border: 2px solid #fff;
    color: #000;
    background-color: #fff;
}

table {
    margin: 1em;
    padding: 0.5em;
    border: 2px solid #222;
    border-collapse: collapse;
    border-spacing: 0;
    color: #000;
    width: 92%;
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
@@ static/css/pretty.css
/* pretty */
.str{color:#080}.kwd{color:#008}.com{color:#800}.typ{color:#606}.lit{color:#066}.pun{color:#660}.pln{color:#000}.tag{color:#008}.atn{color:#606}.atv{color:#080}.dec{color:#606}pre.prettyprint{padding:2px;border:1px solid #888}ol.linenums{margin-top:0;margin-bottom:0}li.L0,li.L1,li.L2,li.L3,li.L5,li.L6,li.L7,li.L8{list-style:none}li.L1,li.L3,li.L5,li.L7,li.L9{background:#eee}@media print{.str{color:#060}.kwd{color:#006;font-weight:bold}.com{color:#600;font-style:italic}.typ{color:#404;font-weight:bold}.lit{color:#044}.pun{color:#440}.pln{color:#000}.tag{color:#006;font-weight:bold}.atn{color:#404}.atv{color:#060}}