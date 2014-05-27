$( document ).ready(function(){

    var player = $("#audio_player");
    var url = player.data('url');
    var vol = player.data('volume');
    var seek= player.data('seek');

    player.prop("volume", vol);


    //URL Anchor Listener
    //window.onhashchange = hashchanged;
    //hashchanged();
});

function hashchanged(){
    //change volume or position without reloading page
    var hash = window.location.hash

        $("#audio_player").jPlayer("volume", hash);

    //TODO add seek functionality
    //$("#audio_player").jPlayer("play", seek);
}
