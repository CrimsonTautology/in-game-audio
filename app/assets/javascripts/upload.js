$( document ).ready(function(){
    //Uploading songs

    $("input#song_sound").change(function(e){
        var file = e.currentTarget.files[0];

        var filename = $(this).val().split("\\").pop();
        filename = filename.substr(0, filename.lastIndexOf('.')) || filename;

        //Scan the uploaded file and auto fill settings
        id3(file, function(err, tags) {
            $("#title").html(tags["title"]);
            $("#artist").html(tags["artist"]);
            $("#album").html(tags["album"]);
            $("#year").html(tags["year"]);
            $("#comment").html(tags["artist"]);
            var genre  = tags["v1"]["genre"];
            $("#genre").html( genre );

            var genre_info = GENRE_MAP[genre]
            if(typeof genre_info !== 'undefined'){
                setCategory(GENRE_MAP[genre]["dir"]);
                //setSubDirectory(GENRE_MAP[genre]["sub"]);
            }
            if(tags["title"]){
                setName(tags["title"]);
            }else if(filename){
                setName(filename);
            }
        });


        //Use a hidden audio control to determine duration of uploaded song
        audio_url = URL.createObjectURL(file);
        $("#audio_demo").prop("src", audio_url);
    });

    $("#audio_demo").on("canplaythrough", function(e){
        var seconds = e.currentTarget.duration;

        //Disable "add as theme" checkbox if duration > 10 seconds
        if(seconds > 10){
            $("#song_add_as_theme").prop("checked", false);
            $("#song_add_as_theme").prop("disabled", true);
        }else{
            $("#song_add_as_theme").prop("disabled", false);
        }
    });

    $("#song_path").change(function(){
        buildHowToPlayCommand();
    });

    $("#song_category").change(function(){
        buildHowToPlayCommand();
    });
});

function buildHowToPlayCommand(){
    var category = $("#song_category option:selected").text().replace(/\/ .*/, "/").trim();
    var path = $("#song_path").val().trim();

    //If both are filled in show the command to play
    if (category != '' && path != ''){
        $("#how_to_play").show();
        $("#how_to_play_command").html(category + path);

    }else{
        $("#how_to_play").hide();
    }
}

function setCategory( key ){
    if (key != null){
        $("select#song_category option").filter(function() {
            return $(this).text().substring(0, key.length) === key
        }).prop('selected', true);
    }
}

function setSubDirectory( key ){
    if (key != null && $("input#song_path").val() == ""){
        $("input#song_path").val(key);
    }

}

function setName( name ){
    if (name != null && $("input#song_path").val() == ""){
        $("input#song_path").val(PathNamify(name, 16));
    }

}


var GENRE_MAP = {
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

//Modified from
//https://gist.github.com/pjambet/3710461
var LATIN_MAP = {
    'À': 'A', 'Á': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A', 'Æ': 'AE', 'Ç':
    'C', 'È': 'E', 'É': 'E', 'Ê': 'E', 'Ë': 'E', 'Ì': 'I', 'Í': 'I', 'Î': 'I',
    'Ï': 'I', 'Ð': 'D', 'Ñ': 'N', 'Ò': 'O', 'Ó': 'O', 'Ô': 'O', 'Õ': 'O', 'Ö':
    'O', 'Ő': 'O', 'Ø': 'O', 'Ù': 'U', 'Ú': 'U', 'Û': 'U', 'Ü': 'U', 'Ű': 'U',
    'Ý': 'Y', 'Þ': 'TH', 'ß': 'ss', 'à':'a', 'á':'a', 'â': 'a', 'ã': 'a', 'ä':
    'a', 'å': 'a', 'æ': 'ae', 'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ð': 'd', 'ñ': 'n', 'ò': 'o', 'ó':
    'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ő': 'o', 'ø': 'o', 'ù': 'u', 'ú': 'u',
    'û': 'u', 'ü': 'u', 'ű': 'u', 'ý': 'y', 'þ': 'th', 'ÿ': 'y'
}
var LATIN_SYMBOLS_MAP = {
    '©':'(c)'
}
var GREEK_MAP = {
    'α':'a', 'β':'b', 'γ':'g', 'δ':'d', 'ε':'e', 'ζ':'z', 'η':'h', 'θ':'8',
    'ι':'i', 'κ':'k', 'λ':'l', 'μ':'m', 'ν':'n', 'ξ':'3', 'ο':'o', 'π':'p',
    'ρ':'r', 'σ':'s', 'τ':'t', 'υ':'y', 'φ':'f', 'χ':'x', 'ψ':'ps', 'ω':'w',
    'ά':'a', 'έ':'e', 'ί':'i', 'ό':'o', 'ύ':'y', 'ή':'h', 'ώ':'w', 'ς':'s',
    'ϊ':'i', 'ΰ':'y', 'ϋ':'y', 'ΐ':'i',
    'Α':'A', 'Β':'B', 'Γ':'G', 'Δ':'D', 'Ε':'E', 'Ζ':'Z', 'Η':'H', 'Θ':'8',
    'Ι':'I', 'Κ':'K', 'Λ':'L', 'Μ':'M', 'Ν':'N', 'Ξ':'3', 'Ο':'O', 'Π':'P',
    'Ρ':'R', 'Σ':'S', 'Τ':'T', 'Υ':'Y', 'Φ':'F', 'Χ':'X', 'Ψ':'PS', 'Ω':'W',
    'Ά':'A', 'Έ':'E', 'Ί':'I', 'Ό':'O', 'Ύ':'Y', 'Ή':'H', 'Ώ':'W', 'Ϊ':'I',
    'Ϋ':'Y'
}
var TURKISH_MAP = {
    'ş':'s', 'Ş':'S', 'ı':'i', 'İ':'I', 'ç':'c', 'Ç':'C', 'ü':'u', 'Ü':'U',
    'ö':'o', 'Ö':'O', 'ğ':'g', 'Ğ':'G'
}
var RUSSIAN_MAP = {
    'а':'a', 'б':'b', 'в':'v', 'г':'g', 'д':'d', 'е':'e', 'ё':'yo', 'ж':'zh',
    'з':'z', 'и':'i', 'й':'j', 'к':'k', 'л':'l', 'м':'m', 'н':'n', 'о':'o',
    'п':'p', 'р':'r', 'с':'s', 'т':'t', 'у':'u', 'ф':'f', 'х':'h', 'ц':'c',
    'ч':'ch', 'ш':'sh', 'щ':'sh', 'ъ':'', 'ы':'y', 'ь':'', 'э':'e', 'ю':'yu',
    'я':'ya',
    'А':'A', 'Б':'B', 'В':'V', 'Г':'G', 'Д':'D', 'Е':'E', 'Ё':'Yo', 'Ж':'Zh',
    'З':'Z', 'И':'I', 'Й':'J', 'К':'K', 'Л':'L', 'М':'M', 'Н':'N', 'О':'O',
    'П':'P', 'Р':'R', 'С':'S', 'Т':'T', 'У':'U', 'Ф':'F', 'Х':'H', 'Ц':'C',
    'Ч':'Ch', 'Ш':'Sh', 'Щ':'Sh', 'Ъ':'', 'Ы':'Y', 'Ь':'', 'Э':'E', 'Ю':'Yu',
    'Я':'Ya'
}
var UKRAINIAN_MAP = {
    'Є':'Ye', 'І':'I', 'Ї':'Yi', 'Ґ':'G', 'є':'ye', 'і':'i', 'ї':'yi', 'ґ':'g'
}
var CZECH_MAP = {
    'č':'c', 'ď':'d', 'ě':'e', 'ň': 'n', 'ř':'r', 'š':'s', 'ť':'t', 'ů':'u',
    'ž':'z', 'Č':'C', 'Ď':'D', 'Ě':'E', 'Ň': 'N', 'Ř':'R', 'Š':'S', 'Ť':'T',
    'Ů':'U', 'Ž':'Z'
}
 
var POLISH_MAP = {
    'ą':'a', 'ć':'c', 'ę':'e', 'ł':'l', 'ń':'n', 'ó':'o', 'ś':'s', 'ź':'z',
    'ż':'z', 'Ą':'A', 'Ć':'C', 'Ę':'e', 'Ł':'L', 'Ń':'N', 'Ó':'o', 'Ś':'S',
    'Ź':'Z', 'Ż':'Z'
}
 
var LATVIAN_MAP = {
    'ā':'a', 'č':'c', 'ē':'e', 'ģ':'g', 'ī':'i', 'ķ':'k', 'ļ':'l', 'ņ':'n',
    'š':'s', 'ū':'u', 'ž':'z', 'Ā':'A', 'Č':'C', 'Ē':'E', 'Ģ':'G', 'Ī':'i',
    'Ķ':'k', 'Ļ':'L', 'Ņ':'N', 'Š':'S', 'Ū':'u', 'Ž':'Z'
}
 
var ALL_DOWNCODE_MAPS=new Array()
ALL_DOWNCODE_MAPS[0]=LATIN_MAP
ALL_DOWNCODE_MAPS[1]=LATIN_SYMBOLS_MAP
ALL_DOWNCODE_MAPS[2]=GREEK_MAP
ALL_DOWNCODE_MAPS[3]=TURKISH_MAP
ALL_DOWNCODE_MAPS[4]=RUSSIAN_MAP
ALL_DOWNCODE_MAPS[5]=UKRAINIAN_MAP
ALL_DOWNCODE_MAPS[6]=CZECH_MAP
ALL_DOWNCODE_MAPS[7]=POLISH_MAP
ALL_DOWNCODE_MAPS[8]=LATVIAN_MAP
 
var Downcoder = new Object();
Downcoder.Initialize = function()
{
    if (Downcoder.map) // already made
        return ;
    Downcoder.map ={}
    Downcoder.chars = '' ;
    for(var i in ALL_DOWNCODE_MAPS)
    {
        var lookup = ALL_DOWNCODE_MAPS[i]
        for (var c in lookup)
        {
            Downcoder.map[c] = lookup[c] ;
            Downcoder.chars += c ;
        }
     }
    Downcoder.regex = new RegExp('[' + Downcoder.chars + ']|[^' + Downcoder.chars + ']+','g') ;
}
 
downcode= function( slug )
{
    Downcoder.Initialize() ;
    var downcoded =""
    var pieces = slug.match(Downcoder.regex);
    if(pieces)
    {
        for (var i = 0 ; i < pieces.length ; i++)
        {
            if (pieces[i].length == 1)
            {
                var mapped = Downcoder.map[pieces[i]] ;
                if (mapped != null)
                {
                    downcoded+=mapped;
                    continue ;
                }
            }
            downcoded+=pieces[i];
        }
    }
    else
    {
        downcoded = slug;
    }
    return downcoded;
}
 
 
function PathNamify(s, num_chars) {
    // changes, e.g., "Petty theft" to "petty_theft"
    // remove all these words from the string before urlifying
    s = downcode(s);
    //
    // if downcode doesn't hit, the char will be stripped here
    s = s.replace(/[^-\w\s\/]/g, '');  // remove unneeded chars
    s = s.replace(/^\s+|\s+$/g, ''); // trim leading/trailing spaces
    s = s.replace(/[-\s]+/g, '_');   // convert spaces to underscores
    s = s.toLowerCase();             // convert to lowercase
    return s.substring(0, num_chars);// trim to first num_chars chars
}
