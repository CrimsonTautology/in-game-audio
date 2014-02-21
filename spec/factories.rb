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
    sound "crap"
    sound_file_name
    sound_content_type "audio/mp3"
    sound_file_size 320214
    sound_fingerprint
  end

  sequence :sound_file_name do |n|
    "song#{n}.mp3"
  end

  sequence :sound_fingerprint do |n|
    "fingerprint#{n}"
  end

end
