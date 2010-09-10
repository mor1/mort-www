// see <http://www.madeincima.eu/blog/jquery-tutorial-external-links/>

$(document).ready(function(){
    $("a[href*='http://']:not([href*='"+location.hostname+"']),[href*='https://']:not([href*='"+location.hostname+"'])")
        .addClass("external")
        .attr("target","_blank")
        .attr("title","Opens new window");
});
