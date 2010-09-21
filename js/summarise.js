$(document).ready(function(){
    
    var expandall_show = "<a class='label showall' title='show all' href=''>show all...</a>";
    var summary_label_show = "<a class='label show' title='show' href=''>show...</a>";
    var summary_label_hide = "<a class='label hide' title='hide' href=''>hide...</a>";
    var summary_body = "<div class='body' />";

    var summaries = $(".summarise");
    summaries.filter(".visible").each(function() {
        $(this).wrapInner(summary_body).prepend(summary_label_hide);
        });
    summaries.filter(".hidden").each(function() {
        $(this).wrapInner(summary_body).prepend(summary_label_show);
        $(this).children(".body").hide();
        });
    $(".summarise a.label").click(function(evt){
        $(this).siblings(".body").slideToggle();
      
        $(this).attr("title", function(idx,oattr) {
            if (oattr == 'show') {
                $(this).attr("title", "hide");
                $(this).text("hide...");
            } else {
              $(this).attr("title", "show");
              $(this).text("show...");
            }
        });
        evt.preventDefault();
    });

    $("#page").prepend(expandall_show);
    $("#page a.showall").click(function(evt){
        if ($(this).attr("title") == "show all") {
            $(".summarise").children(".label").filter(function() {
                return $(this).attr("title") == "show";
            }).each(function(){ 
                $(this).click(); 
                $(this).attr("title", "hide");
                $(this).text("hide...");
            });
            $(this).attr("title", "hide all");
            $(this).text("hide all...");
        } else {
            $(".summarise").children(".label").filter(function() {
                return $(this).attr("title") == "hide";
            }).each(function(){ 
                $(this).click(); 
                $(this).attr("title", "show");
                $(this).text("show...");
            });
            $(this).attr("title", "show all");
            $(this).text("show all...");
        }
        evt.preventDefault();
    });
});
