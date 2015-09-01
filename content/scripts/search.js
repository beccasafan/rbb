$("input[type=checkbox]", "#search").on("change", function() {
    var $this = $(this);
    var $label = $this.parents(".prop").find(".label");
    if ($this.is(":checked")) {
        $label.addClass("success").removeClass("secondary");
    } else {
        $label.addClass("secondary").removeClass("success");
    }

    var checkedProps = $("#search .prop input[type=checkbox]:checked");
    var filterString = _.map(checkedProps.parents(".prop").find(".label"), function(match) { return "." + $(match).text(); }).join(", ");
    $("#search #concerts").isotope({filter: filterString });
});

$("#search #concerts").isotope({
    itemSelector: ".isotope",
    layoutMode: "fitRows"
});