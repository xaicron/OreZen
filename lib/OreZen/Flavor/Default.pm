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
var dateTimer = setInterval(function() {
    document.getElementById('date').innerHTML = (new Date()).toLocaleString();
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
    replaceClass(slides[current++], [NC, VC], PC);
    replaceClass(slides[current], [PC, NC], VC);
    location.hash = current + 1;
}
function prev() {
    replaceClass(slides[current--], [PC, VC], NC);
    replaceClass(slides[current], [PC, NC], VC);
    location.hash = current + 1;
}
function nextlist() {
    removeClass(slides[current], 'focus');
    stash[current++].class = PC;
    addClass(slides[current], 'focus');
    stash[current].class = VC;
    location.hash = current + 1;
}
function prevlist() {
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
    background-color: #000;
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
}

body > section {
    position: absolute;
    top: 5%;
    bottom: 5%;
    left: 3%;
    background: #333;
    color: #fff;
    text-shadow: rgba(0,0,0,0.1) 2px 2px;
    letter-spacing: 0.15em;
    padding: 1%;
    height: 0%;
    overflow: auto;
    width: 92%;
    border-radius: 20px;
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
    right: 4.5%;
    bottom: 3%;
    font-weight: bold;
    display: block;
    text-shadow: 3px 3px 5px #000;
    opacity: 0.7;
}

#date {
    color: #fff;
    position: absolute;
    font-size: 40%;
    left: 4.5%;
    bottom: 3.2%;
    font-weight: bold;
    display: block;
    text-shadow: 3px 3px 5px #000;
    opacity: 0.7;
}

.next {
    top: -100%;
    height: 88%;
#    -moz-transition: all 0.5s ease-in-out;
#    -webkit-transition: all 0.5s ease-in-out;
#    -o-transition: all 0.5s ease-in-out;
#    -ms-transition: all 0.5s ease-in-out;
#    transition: all 0.5s ease-in-out;
}

.prev {
    bottom: -100%;
    height: 88%;
#    -moz-transition: all 0.5s ease-in-out;
#    -webkit-transition: all 0.5s ease-in-out;
#    -o-transition: all 0.5s ease-in-out;
#    -ms-transition: all 0.5s ease-in-out;
#    transition: all 0.5s ease-in-out;
}

.view {
    height: 88%;
    opacity: 1;
#    -moz-transition: all 0.5s ease-in-out;
#    -webkit-transition: all 0.5s ease-in-out;
#    -o-transition: all 0.5s ease-in-out;
#    -ms-transition: all 0.5s ease-in-out;
#    transition: all 0.5s ease-in-out;
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
    margin: 1.3%;
    left: 0%;
    top: 0%;
    bottom: 0%;
    float: left;
    opacity: 0.5;
    border-radius: 20px;
    position: relative;
    border: 1px solid #000;
/*    overflow: hidden; */
#    -moz-transition: opacity 0.3s ease-in-out;
#    -webkit-transition: opacity 0.3s ease-in-out;
#    -o-transition: opacity 0.3s ease-in-out;
#    -ms-transition: opacity 0.3s ease-in-out;
#    transition: opacity 0.3s ease-in-out;
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
    font-size: 45%;
    border: 2px solid #fff;
    color: #000;
    background-color: #fff;
    font-family: 'Monaco' monospace;
    text-shadow: none;
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

#dummy {
    clear: left;
    height: 1px;
}

@@ static/css/pretty.css
/* pretty */
.str{color:#080}.kwd{color:#008}.com{color:#800}.typ{color:#606}.lit{color:#066}.pun{color:#660}.pln{color:#000}.tag{color:#008}.atn{color:#606}.atv{color:#080}.dec{color:#606}pre.prettyprint{padding:2px;border:1px solid #888}ol.linenums{margin-top:0;margin-bottom:0}li.L0,li.L1,li.L2,li.L3,li.L5,li.L6,li.L7,li.L8{list-style:none}li.L1,li.L3,li.L5,li.L7,li.L9{background:#eee}@media print{.str{color:#060}.kwd{color:#006;font-weight:bold}.com{color:#600;font-style:italic}.typ{color:#404;font-weight:bold}.lit{color:#044}.pun{color:#440}.pln{color:#000}.tag{color:#006;font-weight:bold}.atn{color:#404}.atv{color:#060}}
