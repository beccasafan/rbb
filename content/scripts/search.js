$("#props").on("click", ".prop", function() {
    toggleStatus(this)
    doSearch();
});

$("input[type=radio]", "#search").on("change", function() {
    doSearch();
});


$("#search #concerts").isotope({
    itemSelector: ".isotope",
    layoutMode: "masonry"
});

function toggleStatus(element) {
    console.log(element);
    var $this = $(element);
    if ($this.hasClass("success")) {
        $this.removeClass("success").addClass("secondary");
    } else {
        $this.removeClass("secondary").addClass("success");
    }
}

function doSearch() {
    var checkedProps = $("#search .prop.success");
    var terms = checkedProps.text();
    var joiner = $("#mode :radio:checked").val() == "and" ? "" : ", ";
    var filterString = _.map(checkedProps, function(match) { return "." + $(match).text(); }).join(joiner);
    console.log(filterString);
    $("#search #concerts").isotope({filter: filterString });
}