$(document).ready(function(){
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
});
