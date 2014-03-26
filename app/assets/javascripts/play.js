$( document ).ready(function(){
    //jPlayer - Default to auto play
    var player = $("#audio_player");
    var url = player.data('url');
    var vol = player.data('volume');
    var seek= player.data('seek');

    player.jPlayer({
      ready: function(event) {
        $(this).jPlayer("setMedia", {
          mp3: url
        }).jPlayer("play", seek);
      },
      supplied: "mp3",
      swfPath: "/",
      volume: vol,
      preload: "auto"
    });

    //URL Anchor Listener
    window.onhashchange = hashchanged;
    //hashchanged();
});

function hashchanged(){
    //change volume or position without reloading page
    var hash = window.location.hash

    $("#audio_player").jPlayer("volume", hash);

    //TODO add seek functionality
    //$("#audio_player").jPlayer("play", seek);
}
