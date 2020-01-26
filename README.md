# DEPRECATED
This will no longer work due to changes to the in-game Chromium web browser.

# In Game Audio

[![Build Status](https://travis-ci.org/CrimsonTautology/in_game_audio.png?branch=master)](https://travis-ci.org/CrimsonTautology/in_game_audio)

The back website for the [In Game Audio](https://github.com/CrimsonTautology/sm_in_game_audio) sourcemod plugin.  Allows a person to upload songs which can then be played back in game through the HTML5 MOTD browser.

## Requirements
* Ruby 2.0
* A [Steam Web API Key](http://steamcommunity.com/dev)
* [postgresql](http://www.postgresql.org/)
* A game server running [Sourcemod](http://www.sourcemod.net) and the [sm_in_game_audio](https://github.com/CrimsonTautology/sm_in_game_audio) plugin.
* A [Google Storage for Developers](http://gs-signup-redirect.appspot.com/) account. Get your credentials [here](https://storage.cloud.google.com/m)
* [FFMPEG](http://www.ffmpeg.org/) with OGG Vorbis support.

## Instalation
* Make sure you have the requirements
* Add your steam API key to your system's environment: `STEAM_API_KEY=[your api key]`
* Add your Google storage directory, access key id and secret access key to your system's environment: `GOOGLE_STORAGE_DIRECTORY=[your key] GOOGLE_STORAGE_ACCESS_KEY_ID=[your key] GOOGLE_STORAGE_SECRET_ACCESS_KEY=[your key]`
* Add the [steam ID 64](http://steamidconverter.com/) for the head admin in to your system's environment: `STEAM_HEAD_ADMIN_ID=[your steamid 64]`
* Setup your database config in `config/database.yml`
* Install bundler and all required gems: `gem install bundler && bundle`
* Initialize your database with: `rake db:setup`
* Start the webserver: `thin start`

## Usage
Go [here](http://iga.serverisnotcrash.com/directories) to find a song you want to play.

Every song on that site can be played with the `!p` chat command.  Calling `!p` by itself will play a random song to yourself. You can also call `!p` with a category to play a random song in that category: `!p r` will play a random song in [the rock category](http://iga.serverisnotcrash.com/directories/70). This works with subdirectories of a category as well.  To play a specific song, give the category it is in followed by a forward slash '/' and then the name.  For example to play ["takefive"](http://iga.serverisnotcrash.com/songs/153) in the ["j"](http://iga.serverisnotcrash.com/directories/60) category you would type `!p j/takefive` into the in-game chat-box.

![Example](http://i.imgur.com/VuiWlgF.gif)

