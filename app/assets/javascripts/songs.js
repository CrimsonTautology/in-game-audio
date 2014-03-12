$( document ).ready(function(){

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
        'Blues': { dir: "b/", sub: null },
        'Classic Rock': { dir: "r/", sub: "c/" },
        'Country': { dir: "cntry/", sub: null },
        'Dance': { dir: "d/", sub: null },
        'Disco': { dir: "d/", sub: null },
        'Funk': { dir: "d/", sub: null },
        'Grunge': { dir: null, sub: null },
        'Hip-Hop': { dir: null, sub: null },
        'Jazz': { dir: "j/", sub: null },
        'Metal': { dir: null, sub: null },
        'New Age': { dir: null, sub: null },
        'Oldies': { dir: null, sub: null },
        'Other': { dir: "g/", sub: null },
        'Pop': { dir: "pop/", sub: null },
        'R&B': { dir: null, sub: null },
        'Rap': { dir: "rap/", sub: null },
        'Reggae': { dir: "reg/", sub: null },
        'Rock': { dir: "r/", sub: null },
        'Techno': { dir: null, sub: null },
        'Industrial': { dir: null, sub: null },
        'Alternative': { dir: null, sub: null },
        'Ska': { dir: "ska/", sub: null },
        'Death Metal': { dir: null, sub: null },
        'Pranks': { dir: "com/", sub: "prank/" },
        'Soundtrack': { dir: "tv/", sub: null },
        'Euro-Techno': { dir: null, sub: null },
        'Ambient': { dir: null, sub: null },
        'Trip-Hop': { dir: null, sub: null },
        'Vocal': { dir: null, sub: null },
        'Jazz+Funk': { dir: "j/", sub: null },
        'Fusion': { dir: null, sub: null },
        'Trance': { dir: null, sub: null },
        'Classical': { dir: "c/", sub: null },
        'Instrumental': { dir: "in/", sub: null },
        'Acid': { dir: null, sub: null },
        'House': { dir: null, sub: null },
        'Game': { dir: "v/", sub: null },
        'Sound Clip': { dir: "sfx/", sub: null },
        'Gospel': { dir: null, sub: null },
        'Noise': { dir: "n/", sub: null },
        'AlternRock': { dir: "r/", sub: "a/" },
        'Bass': { dir: null, sub: null },
        'Soul': { dir: null, sub: null },
        'Punk': { dir: "pu/", sub: null },
        'Space': { dir: null, sub: null },
        'Meditative': { dir: null, sub: null },
        'Instrumental Pop': { dir: "pop/", sub: "in/" },
        'Instrumental Rock': { dir: "r/", sub: "in/" },
        'Ethnic': { dir: null, sub: null },
        'Gothic': { dir: null, sub: null },
        'Darkwave': { dir: null, sub: null },
        'Techno-Industrial': { dir: null, sub: null },
        'Electronic': { dir: "e/", sub: null },
        'Pop-Folk': { dir: "f/", sub: "pop/" },
        'Eurodance': { dir: null, sub: null },
        'Dream': { dir: null, sub: null },
        'Southern Rock': { dir: null, sub: null },
        'Comedy': { dir: "com/", sub: null },
        'Cult': { dir: null, sub: null },
        'Gangsta Rap': { dir: "rap/", sub: null },
        'Top 40': { dir: null, sub: null },
        'Christian Rap': { dir: "rap/", sub: null },
        'Pop / Funk': { dir: null, sub: null },
        'Jungle': { dir: null, sub: null },
        'Native American': { dir: null, sub: null },
        'Cabaret': { dir: null, sub: null },
        'New Wave': { dir: null, sub: null },
        'Psychedelic': { dir: null, sub: null },
        'Rave': { dir: null, sub: null },
        'Showtunes': { dir: null, sub: null },
        'Trailer': { dir: "mv/", sub: null },
        'Lo-Fi': { dir: null, sub: null },
        'Tribal': { dir: null, sub: null },
        'Acid Punk': { dir: null, sub: null },
        'Acid Jazz': { dir: null, sub: null },
        'Polka': { dir: null, sub: null },
        'Retro': { dir: null, sub: null },
        'Musical': { dir: "m/", sub: null },
        'Rock & Roll': { dir: "r/", sub: null },
        'Hard Rock': { dir: "r/", sub: null },
        'Folk': { dir: "f/", sub: null },
        'Folk-Rock': { dir: "f/", sub: "r/" },
        'National Folk': { dir: "f/", sub: "nat/" },
        'Swing': { dir: null, sub: null },
        'Fast  Fusion': { dir: null, sub: null },
        'Bebob': { dir: null, sub: null },
        'Latin': { dir: null, sub: null },
        'Revival': { dir: null, sub: null },
        'Celtic': { dir: null, sub: null },
        'Bluegrass': { dir: null, sub: null },
        'Avantgarde': { dir: null, sub: null },
        'Gothic Rock': { dir: "r/", sub: "goth/" },
        'Progressive Rock': { dir: "r/", sub: "pro/" },
        'Psychedelic Rock': { dir: "r/", sub: "psy/" },
        'Symphonic Rock': { dir: "r/", sub: "sym/" },
        'Slow Rock': { dir: "r/", sub: "slow/" },
        'Big Band': { dir: "j/", sub: null },
        'Chorus': { dir: null, sub: null },
        'Easy Listening': { dir: null, sub: null },
        'Acoustic': { dir: null, sub: null },
        'Humour': { dir: "com/", sub: null },
        'Speech': { dir: "sw/", sub: null },
        'Chanson': { dir: null, sub: null },
        'Opera': { dir: "c/", sub: "o/" },
        'Chamber Music': { dir: null, sub: null },
        'Sonata': { dir: null, sub: null },
        'Symphony': { dir: "c/", sub: "sym/" },
        'Booty Bass': { dir: null, sub: null },
        'Primus': { dir: null, sub: null },
        'Porn Groove': { dir: "g/", sub: null },
        'Satire': { dir: null, sub: null },
        'Slow Jam': { dir: null, sub: null },
        'Club': { dir: null, sub: null },
        'Tango': { dir: null, sub: null },
        'Samba': { dir: null, sub: null },
        'Folklore': { dir: null, sub: null },
        'Ballad': { dir: null, sub: null },
        'Power Ballad': { dir: null, sub: null },
        'Rhythmic Soul': { dir: null, sub: null },
        'Freestyle': { dir: null, sub: null },
        'Duet': { dir: null, sub: null },
        'Punk Rock': { dir: "pu/", sub: null },
        'Drum Solo': { dir: null, sub: null },
        'A Cappella': { dir: null, sub: null },
        'Euro-House': { dir: null, sub: null },
        'Dance Hall': { dir: null, sub: null },
        'Goa': { dir: null, sub: null },
        'Drum & Bass': { dir: null, sub: null },
        'Club-House': { dir: null, sub: null },
        'Hardcore': { dir: null, sub: null },
        'Terror': { dir: null, sub: null },
        'Indie': { dir: null, sub: null },
        'BritPop': { dir: null, sub: null },
        'Negerpunk': { dir: null, sub: null },
        'Polsk Punk': { dir: null, sub: null },
        'Beat': { dir: null, sub: null },
        'Christian Gangsta Rap': { dir: "rap/", sub: null },
        'Heavy Metal': { dir: null, sub: null },
        'Black Metal': { dir: null, sub: null },
        'Crossover': { dir: null, sub: null },
        'Contemporary Christian': { dir: null, sub: null },
        'Christian Rock': { dir: null, sub: null },
        'Merengue': { dir: null, sub: null },
        'Salsa': { dir: null, sub: null },
        'Thrash Metal': { dir: null, sub: null },
        'Anime': { dir: "a/", sub: null },
        'JPop': { dir: "jpop/", sub: null },
        'Synthpop': { dir: "pop/", sub: null },
        'Rock/Pop': { dir: null, sub: null }
    };


});
