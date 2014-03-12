$( document ).ready(function(){

    $("input#song_sound").change(function(){
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
        'Blues': { dir: null, sub: null },
        'Classic Rock': { dir: null, sub: null },
        'Country': { dir: null, sub: null },
        'Dance': { dir: null, sub: null },
        'Disco': { dir: null, sub: null },
        'Funk': { dir: null, sub: null },
        'Grunge': { dir: null, sub: null },
        'Hip-Hop': { dir: null, sub: null },
        'Jazz': { dir: null, sub: null },
        'Metal': { dir: null, sub: null },
        'New Age': { dir: null, sub: null },
        'Oldies': { dir: null, sub: null },
        'Other': { dir: null, sub: null },
        'Pop': { dir: null, sub: null },
        'R&B': { dir: null, sub: null },
        'Rap': { dir: null, sub: null },
        'Reggae': { dir: null, sub: null },
        'Rock': { dir: null, sub: null },
        'Techno': { dir: null, sub: null },
        'Industrial': { dir: null, sub: null },
        'Alternative': { dir: null, sub: null },
        'Ska': { dir: "ska/", sub: null },
        'Death Metal': { dir: null, sub: null },
        'Pranks': { dir: null, sub: null },
        'Soundtrack': { dir: null, sub: null },
        'Euro-Techno': { dir: null, sub: null },
        'Ambient': { dir: null, sub: null },
        'Trip-Hop': { dir: null, sub: null },
        'Vocal': { dir: null, sub: null },
        'Jazz+Funk': { dir: null, sub: null },
        'Fusion': { dir: null, sub: null },
        'Trance': { dir: null, sub: null },
        'Classical': { dir: "c/", sub: null },
        'Instrumental': { dir: null, sub: null },
        'Acid': { dir: null, sub: null },
        'House': { dir: null, sub: null },
        'Game': { dir: null, sub: null },
        'Sound Clip': { dir: null, sub: null },
        'Gospel': { dir: null, sub: null },
        'Noise': { dir: null, sub: null },
        'AlternRock': { dir: null, sub: null },
        'Bass': { dir: null, sub: null },
        'Soul': { dir: null, sub: null },
        'Punk': { dir: null, sub: null },
        'Space': { dir: null, sub: null },
        'Meditative': { dir: null, sub: null },
        'Instrumental Pop': { dir: null, sub: null },
        'Instrumental Rock': { dir: null, sub: null },
        'Ethnic': { dir: null, sub: null },
        'Gothic': { dir: null, sub: null },
        'Darkwave': { dir: null, sub: null },
        'Techno-Industrial': { dir: null, sub: null },
        'Electronic': { dir: null, sub: null },
        'Pop-Folk': { dir: null, sub: null },
        'Eurodance': { dir: null, sub: null },
        'Dream': { dir: null, sub: null },
        'Southern Rock': { dir: null, sub: null },
        'Comedy': { dir: null, sub: null },
        'Cult': { dir: null, sub: null },
        'Gangsta Rap': { dir: null, sub: null },
        'Top 40': { dir: null, sub: null },
        'Christian Rap': { dir: null, sub: null },
        'Pop / Funk': { dir: null, sub: null },
        'Jungle': { dir: null, sub: null },
        'Native American': { dir: null, sub: null },
        'Cabaret': { dir: null, sub: null },
        'New Wave': { dir: null, sub: null },
        'Psychedelic': { dir: null, sub: null },
        'Rave': { dir: null, sub: null },
        'Showtunes': { dir: null, sub: null },
        'Trailer': { dir: null, sub: null },
        'Lo-Fi': { dir: null, sub: null },
        'Tribal': { dir: null, sub: null },
        'Acid Punk': { dir: null, sub: null },
        'Acid Jazz': { dir: null, sub: null },
        'Polka': { dir: null, sub: null },
        'Retro': { dir: null, sub: null },
        'Musical': { dir: null, sub: null },
        'Rock & Roll': { dir: null, sub: null },
        'Hard Rock': { dir: null, sub: null },
        'Folk': { dir: null, sub: null },
        'Folk-Rock': { dir: null, sub: null },
        'National Folk': { dir: null, sub: null },
        'Swing': { dir: null, sub: null },
        'Fast  Fusion': { dir: null, sub: null },
        'Bebob': { dir: null, sub: null },
        'Latin': { dir: null, sub: null },
        'Revival': { dir: null, sub: null },
        'Celtic': { dir: null, sub: null },
        'Bluegrass': { dir: null, sub: null },
        'Avantgarde': { dir: null, sub: null },
        'Gothic Rock': { dir: null, sub: null },
        'Progressive Rock': { dir: null, sub: null },
        'Psychedelic Rock': { dir: null, sub: null },
        'Symphonic Rock': { dir: null, sub: null },
        'Slow Rock': { dir: null, sub: null },
        'Big Band': { dir: null, sub: null },
        'Chorus': { dir: null, sub: null },
        'Easy Listening': { dir: null, sub: null },
        'Acoustic': { dir: null, sub: null },
        'Humour': { dir: null, sub: null },
        'Speech': { dir: null, sub: null },
        'Chanson': { dir: null, sub: null },
        'Opera': { dir: null, sub: null },
        'Chamber Music': { dir: null, sub: null },
        'Sonata': { dir: null, sub: null },
        'Symphony': { dir: null, sub: null },
        'Booty Bass': { dir: null, sub: null },
        'Primus': { dir: null, sub: null },
        'Porn Groove': { dir: null, sub: null },
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
        'Punk Rock': { dir: null, sub: null },
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
        'Christian Gangsta Rap': { dir: null, sub: null },
        'Heavy Metal': { dir: null, sub: null },
        'Black Metal': { dir: null, sub: null },
        'Crossover': { dir: null, sub: null },
        'Contemporary Christian': { dir: null, sub: null },
        'Christian Rock': { dir: null, sub: null },
        'Merengue': { dir: null, sub: null },
        'Salsa': { dir: null, sub: null },
        'Thrash Metal': { dir: null, sub: null },
        'Anime': { dir: null, sub: null },
        'JPop': { dir: null, sub: null },
        'Synthpop': { dir: null, sub: null },
        'Rock/Pop': { dir: null, sub: null }
    };


});
