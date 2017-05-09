include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :directory do
    name "foo"
    parent :root
    root false
  end

  factory :root, class: Directory do
    name ""
    parent nil
    root true
  end

  factory :song do
    name "baz"
    directory :root
    association :uploader, factory: :user
    duration 500
    sound "crap"
    sound_file_name
    sound_content_type "audio/mp3"
    sound_file_size 320214
    sound_fingerprint

    factory :banned_song do
      banned_at Time.now
    end
  end

  sequence :sound_file_name do |n|
    "song#{n}.mp3"
  end

  sequence :sound_fingerprint do |n|
    "fingerprint#{n}"
  end

  factory :api_key do
    name "Test Server"
  end

  factory :play_event do
    song
    api_key
    type_of "p"
  end

  factory :user do
    nickname "FooBar"
    uid
    provider "steam"

    factory :admin do
      admin true
    end
    factory :uploader do
      uploader true
    end
    factory :banned do
      banned_at Time.now
    end
  end

  sequence :uid do |n|
    "12345#{n}"
  end

  factory :theme do
    user
    song
  end

end
