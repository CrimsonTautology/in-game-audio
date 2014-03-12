$( document ).ready(function(){

    $("input#sound").change(function(){
        id3(this.files[0], function(err, tags) {
            $("#title").html(tags["title"]);
            $("#artist").html(tags["artist"]);
            $("#album").html(tags["album"]);
            $("#year").html(tags["year"]);
            $("#comment").html(tags["artist"]);
            var genre  = tags["v1"]["genre"];
            $("#genre").html( genre );
            setCategory(genre);
        });
    });

    function setCategory( genre ){
        $("input#directory").val('test');
    }


});
