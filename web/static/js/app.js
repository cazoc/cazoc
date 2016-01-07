// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

window.addEventListener("DOMContentLoaded", main);
window.addEventListener("hashchange", main);

var get = $.get;
marked.setOptions({
    renderer: new marked.Renderer(),
    gfm: true,
    tables: true,
    breaks: true,
    pedantic: false,
    sanitize: false,
    smartLists: false,
    smartypants: false
});

function main(){
    var name = "";
    if ( location.hash.length <= 1 ) {
        name = "index.md";
        location.hash = "#" + name;
    } else {
        name = location.hash.slice(1);
    }
    // ページ内リンクなのでhistory.pushStateする必要はない
    get(name).catch(function(){
        return Promise.resolve("# 404 page not found");
    }).then(function(text){
        // markedにlatexタグ食わせると&<>とかがエスケープされるので<pre />で包んで退避
        // ちなみに```mathとかで<pre><code class="lang-math">になったのはエスケープされるので注意
        var PREFIX = "<pre><code class=\"lang-math\">";
        var SUFFIX = "</code></pre>";
        var reg = new RegExp(
            ("(?:" + PREFIX + "([\\s\\S]*?)" + SUFFIX + ")")
                .replace(/\//g, "\/"),
            "gm");
        var wraped = text.split("$$")
            .reduce(function(sum, str, i){
                return i % 2 === 0 ?
                    sum + str :
                    sum + PREFIX + str + SUFFIX;
            }, "");
        var html = marked(wraped);
        // 退避したlatexタグを$$で包み直す
        var _html = html;
        var tuple = null;
        while(tuple = reg.exec(html)){
            _html = _html.split(tuple[0]).join("$$" + tuple[1] + "$$");
        }
        // mathjaxで処理
        var div = document.getElementById("content");
        div.innerHTML = _html;
        MathJax.Hub.Configured();
        MathJax.Hub.Queue(["Typeset", MathJax.Hub, div]);
    }).catch(function(err){
        // jqueryのpromiseはthenの中でエラー吐いて止まってもconsoleに表示してくれないので表示させる
        console.error(err);
    });
}
