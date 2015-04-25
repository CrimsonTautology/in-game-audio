$( document ).ready(function(){

    var player = $('#audio_player');
    var url = player.data('url');
    var vol = player.data('volume');
    var seek= player.data('seek');

    player.prop('volume', vol);

    //URL Anchor Listener
    window.onhashchange = hashchanged;
    //hashchanged();
});

function hashchanged(){
    //change volume or position without reloading page
    var player = $('#audio_player');
    var hash = window.location.hash;

    if(hash.lastIndexOf('#v=', 0) === 0){
        //We're changing volume
        var newVolume = parseVolume(hash);
        newVolume = adjustVolume(newVolume);
        player.prop('volume', newVolume);
    }


}

function parseVolume(unparsed){
    return unparsed.replace('#v=', '');
}

function adjustVolume(unadjusted){
    return Math.pow(unadjusted, 4.0);
}
