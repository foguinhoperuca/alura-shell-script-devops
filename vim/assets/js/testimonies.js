(function() {
    var active_id = 1;
    var testimonies_count = 3;

    var change_testimony = function(new_id) {
        document.querySelector("#figure-" + active_id + "-testimonies").classList.remove("active");
        document.querySelector("#button-" + active_id + "-testimonies").classList.remove("active");
        document.querySelector("#figure-" + new_id + "-testimonies").classList.add("active");
        document.querySelector("#button-" + new_id + "-testimonies").classList.add("active");

        active_id = new_id;
    }

    document.querySelector(".left").addEventListener("click", function() {
        change_testimony(active_id - 1 + testimonies_count * (active_id == 1));
    });

    document.querySelector(".right").addEventListener("click", function() {
        change_testimony(active_id + 1 - testimonies_count * (active_id == testimonies_count));
    });

    for (var i = 1; i<= testimonies_count; i++) {
        (function(id) {
            document.querySelector("#button-" + id + "-testimonies").addEventListener("click", function() {
                change_testimony(id)
            });
        })(i);
    }
})();
