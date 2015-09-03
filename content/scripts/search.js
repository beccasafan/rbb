$("#props").on("click", ".prop", function() {
    toggleStatus(this)
    doSearch();
});

$("input[type=radio]", "#search").on("change", function() {
    doSearch();
});

imagesLoaded("#search #concerts", function() {
    $("#search #concerts").isotope({
        itemSelector: ".isotope",
        layoutMode: "masonry"
    });
});

function toggleStatus(element) {
    var $this = $(element);
    if ($this.hasClass("success")) {
        $this.removeClass("success").addClass("secondary");
    } else {
        $this.removeClass("secondary").addClass("success");
    }
}

function doSearch() {
    var checkedProps = $("#search .prop.success");
    var terms = _.map(checkedProps, function(p) { return "." + $(p).data("prop"); })
    var joiner = $("#mode :radio:checked").val() == "and" ? "" : ", ";
    var filterString = terms.join(joiner);
    $("#search #concerts").isotope({filter: filterString });
}