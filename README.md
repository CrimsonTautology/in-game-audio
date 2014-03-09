# In Game Audio

[![Build Status](https://travis-ci.org/CrimsonTautology/in_game_audio.png?branch=master)](https://travis-ci.org/CrimsonTautology/in_game_audio)

The back website for the [In Game Audio](https://github.com/CrimsonTautology/sm_in_game_audio) sourcemod plugin.  Allows a person to upload songs which can then be played back in game through the HTML5 MOTD browser.

## Requirements
* Ruby 1.9
* A [Steam Web API Key](http://steamcommunity.com/dev)
* [postgresql](http://www.postgresql.org/)
* A game server running [Sourcemod](http://www.sourcemod.net) and the [sm_in_game_audio](https://github.com/CrimsonTautology/sm_in_game_audio) plugin.
* A [Google Storage for Developers](http://gs-signup-redirect.appspot.com/) account. Get your credentials [here](https://storage.cloud.google.com/m)
* [FFMEG](http://www.ffmpeg.org/) with OGG Vorbis support.

## Instalation
* Make sure you have the requirements
* Add your steam API key to your system's environment: `STEAM_API_KEY=[your api key]`
* Add your Google storage directory, access key id and secret access key to your system's environment: `GOOGLE_STORAGE_DIRECTORY=[your key] GOOGLE_STORAGE_ACCESS_KEY_ID=[your key] GOOGLE_STORAGE_SECRET_ACCESS_KEY=[your key]`
* Add the [steam ID 64](http://steamidconverter.com/) for the head admin in to your system's environment: `STEAM_HEAD_ADMIN_ID=[your steamid 64]`
* Setup your database config in `config/database.yml`
* Install bundler and all required gems: `gem install bundler && bundle`
* Initialize your database with: `rake db:setup`
* Start the webserver: `thin start`

