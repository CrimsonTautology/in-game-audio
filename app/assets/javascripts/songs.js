$( document ).ready(function(){

    //ZeroClipboard
    var clip = new ZeroClipboard($(".zeroclipboard-btn"));

    //jPlayer
    var url = $("#audio_player").data('url');
    var vol = $("#audio_player").data('volume');
    var seek= $("#audio_player").data('seek');

    $("#audio_player").jPlayer({
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
    window.hashchange(hashchanged);
    hashchanged();


    //Uploading songs
    $("input#song_sound").change(function(){
        console.log(this.files[0]);
        id3(this.files[0], function(err, tags) {
            //$("input#song_full_path").val('a/');

            $("#title").html(tags["title"]);
            $("#artist").html(tags["artist"]);
            $("#album").html(tags["album"]);
            $("#year").html(tags["year"]);
            $("#comment").html(tags["artist"]);
            var genre  = tags["v1"]["genre"];
            $("#genre").html( genre );
            setCategory(genreHash[genre]["dir"]);
            setSubDirectory(genreHash[genre]["sub"]);
        });
    });

    function setCategory( key ){
        if (key != null){
            $("select#song_directory option").filter(function() {
                return $(this).text().substring(0, key.length) === key
            }).prop('selected', true);
        }
    }

    function setSubDirectory( key ){
        if (key != null && $("input#song_full_path").val() == ""){
            $("input#song_full_path").val(key);
        }

    }


    var genreHash = {
        'Blues': { dir: null, sub: null }, //This is the default genre, disable auto assigning it
        'Classic Rock': { dir: "r/", sub: "c/" },
        'Country': { dir: "ct/", sub: null },
        'Dance': { dir: "h/", sub: null },
        'Disco': { dir: "d/", sub: null },
        'Funk': { dir: "d/", sub: null },
        'Grunge': { dir: "pu/", sub: null },
        'Hip-Hop': { dir: "hh/", sub: null },
        'Jazz': { dir: "j/", sub: null },
        'Metal': { dir: "m/", sub: null },
        'New Age': { dir: "sym/", sub: null },
        'Oldies': { dir: "o/", sub: null },
        'Other': { dir: "g/", sub: null },
        'Pop': { dir: "pop/", sub: null },
        'R&B': { dir: "b/", sub: null },
        'Rap': { dir: "rap/", sub: null },
        'Reggae': { dir: "reg/", sub: null },
        'Rock': { dir: "r/", sub: null },
        'Techno': { dir: "h/", sub: null },
        'Industrial': { dir: "e/", sub: null },
        'Alternative': { dir: "r/", sub: "alt/" },
        'Ska': { dir: "ska/", sub: null },
        'Death Metal': { dir: "m/", sub: null },
        'Pranks': { dir: "com/", sub: "prank/" },
        'Soundtrack': { dir: null, sub: null }, //Could be in fact tv movie or game
        'Euro-Techno': { dir: "h/", sub: null },
        'Ambient': { dir: "h/", sub: null },
        'Trip-Hop': { dir: "e/", sub: null },
        'Vocal': { dir: "sw/", sub: null },
        'Jazz+Funk': { dir: "j/", sub: null },
        'Fusion': { dir: null, sub: null },
        'Trance': { dir: "e/", sub: null },
        'Classical': { dir: "c/", sub: null },
        'Instrumental': { dir: "in/", sub: null },
        'Acid': { dir: "e/", sub: null },
        'House': { dir: "h/", sub: null },
        'Game': { dir: "v/", sub: null },
        'Sound Clip': { dir: "sfx/", sub: null },
        'Gospel': { dir: null, sub: null },
        'Noise': { dir: "n/", sub: null },
        'AlternRock': { dir: "r/", sub: "alt/" },
        'Bass': { dir: null, sub: null },
        'Soul': { dir: "b/", sub: null },
        'Punk': { dir: "pu/", sub: null },
        'Space': { dir: "e/", sub: null },
        'Meditative': { dir: "sym/", sub: null },
        'Instrumental Pop': { dir: "pop/", sub: "in/" },
        'Instrumental Rock': { dir: "r/", sub: "in/" },
        'Ethnic': { dir: "f/", sub: null },
        'Gothic': { dir: "m/", sub: null },
        'Darkwave': { dir: "pu/", sub: null },
        'Techno-Industrial': { dir: "h/", sub: null },
        'Electronic': { dir: "e/", sub: null },
        'Pop-Folk': { dir: "f/", sub: "pop/" },
        'Eurodance': { dir: "h/", sub: null },
        'Dream': { dir: "sym/", sub: null },
        'Southern Rock': { dir: "ct/", sub: null },
        'Comedy': { dir: "com/", sub: null },
        'Cult': { dir: null, sub: null },
        'Gangsta Rap': { dir: "rap/", sub: null },
        'Top 40': { dir: null, sub: null },
        'Christian Rap': { dir: "rap/", sub: null },
        'Pop / Funk': { dir: "d/", sub: null },
        'Jungle': { dir: null, sub: null },
        'Native American': { dir: "f/", sub: null },
        'Cabaret': { dir: null, sub: null },
        'New Wave': { dir: "prog/", sub: null },
        'Psychedelic': { dir: "prog/", sub: null },
        'Rave': { dir: "h/", sub: null },
        'Showtunes': { dir: "o/", sub: null },
        'Trailer': { dir: "mv/", sub: null },
        'Lo-Fi': { dir: null, sub: null },
        'Tribal': { dir: "f/", sub: null },
        'Acid Punk': { dir: "pu/", sub: null },
        'Acid Jazz': { dir: "e/", sub: null },
        'Polka': { dir: "in/", sub: "polka/" },
        'Retro': { dir: "o/", sub: null },
        'Musical': { dir: "mu/", sub: null },
        'Rock & Roll': { dir: "r/", sub: null },
        'Hard Rock': { dir: "r/", sub: null },
        'Folk': { dir: "f/", sub: null },
        'Folk-Rock': { dir: "f/", sub: "r/" },
        'National Folk': { dir: "f/", sub: "nat/" },
        'Swing': { dir: "o/", sub: null },
        'Fast  Fusion': { dir: null, sub: null },
        'Bebob': { dir: "j/", sub: null },
        'Latin': { dir: "l/", sub: null },
        'Revival': { dir: null, sub: null },
        'Celtic': { dir: null, sub: null },
        'Bluegrass': { dir: "ct/", sub: null },
        'Avantgarde': { dir: null, sub: null },
        'Gothic Rock': { dir: "m/", sub: "goth/" },
        'Progressive Rock': { dir: "prog/", sub: null},
        'Psychedelic Rock': { dir: "prog/", sub: null},
        'Symphonic Rock': { dir: "prog/", sub: null},
        'Slow Rock': { dir: "r/", sub: "slow/" },
        'Big Band': { dir: "j/", sub: null },
        'Chorus': { dir: "ch/", sub: null },
        'Easy Listening': { dir: "sym/", sub: null },
        'Acoustic': { dir: "e/", sub: null },
        'Humour': { dir: "com/", sub: null },
        'Speech': { dir: "sw/", sub: null },
        'Chanson': { dir: null, sub: null },
        'Opera': { dir: "c/", sub: "o/" },
        'Chamber Music': { dir: "c/", sub: null },
        'Sonata': { dir: "c/", sub: null },
        'Symphony': { dir: "c/", sub: "sym/" },
        'Booty Bass': { dir: null, sub: null },
        'Primus': { dir: null, sub: null },
        'Porn Groove': { dir: "g/", sub: null },
        'Satire': { dir: "com/", sub: null },
        'Slow Jam': { dir: null, sub: null },
        'Club': { dir: "h/", sub: null },
        'Tango': { dir: "l/", sub: null },
        'Samba': { dir: "l/", sub: null },
        'Folklore': { dir: null, sub: null },
        'Ballad': { dir: null, sub: null },
        'Power Ballad': { dir: null, sub: null },
        'Rhythmic Soul': { dir: null, sub: null },
        'Freestyle': { dir: null, sub: null },
        'Duet': { dir: null, sub: null },
        'Punk Rock': { dir: "pu/", sub: null },
        'Drum Solo': { dir: "in/", sub: null },
        'A Cappella': { dir: null, sub: null },
        'Euro-House': { dir: "h/", sub: null },
        'Dance Hall': { dir: "h/", sub: null },
        'Goa': { dir: null, sub: null },
        'Drum & Bass': { dir: null, sub: null },
        'Club-House': { dir: "h/", sub: null },
        'Hardcore': { dir: "m/", sub: null },
        'Terror': { dir: null, sub: null },
        'Indie': { dir: "r/", sub: "alt/" },
        'BritPop': { dir: "pop/", sub: null },
        'Negerpunk': { dir: "pu/", sub: null },
        'Polsk Punk': { dir: "pu/", sub: null },
        'Beat': { dir: null, sub: null },
        'Christian Gangsta Rap': { dir: "rap/", sub: null },
        'Heavy Metal': { dir: "m/", sub: null },
        'Black Metal': { dir: "m/", sub: null },
        'Crossover': { dir: null, sub: null },
        'Contemporary Christian': { dir: null, sub: null },
        'Christian Rock': { dir: null, sub: null },
        'Merengue': { dir: null, sub: null },
        'Salsa': { dir: "l/", sub: null },
        'Thrash Metal': { dir: "m/", sub: null },
        'Anime': { dir: "a/", sub: null },
        'JPop': { dir: "w/", sub: "j/" },
        'Synthpop': { dir: "pop/", sub: null },
        'Rock/Pop': { dir: "pop/", sub: null }
    };


});

function hashchanged(){
    //change volume or position without reloading page
    var hash = window.location.hash

    $("#audio_player").jPlayer("volume", hash);

    //TODO add seek functionality
    //$("#audio_player").jPlayer("play", seek);
}
