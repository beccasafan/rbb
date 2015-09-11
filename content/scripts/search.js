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

    var searchQS = getParameterByName("props");
    if (searchQS != null && searchQS != "") {
      var propsToSearch = searchQS.split("|");
      _.each(propsToSearch, function(prop) {
        $(".prop[data-prop='" + prop + "']", "#props").click();
      });

      $("html, body").animate({
        scrollTop: $("#concerts").offset().top
      }, 2000);
    }

    var modeQS = getParameterByName("mode");
    if (modeQS != null && modeQS != "") {
      $("input[type=radio][value='" + modeQS + "']", "#mode").click();
    }
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

    var link = "?props=" + _.map(terms, function(t) { return t.substr(1); }).join("|") + "&mode=" + $("#mode :radio:checked").val();
    var newLink = window.location.pathname + link;
    $("#searchLink, #searchLink2").attr("href", newLink);
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
