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
    #sound { fixture_file_upload(Rails.root.join("spec", "songs", "test.mp3"), "audio/mp3") }
    sound_file_name "test.mp3"
    sound_content_type "audio/mp3"
    sound_file_size 8414449
    sound_fingerprint "fingerprint" 
  end

end
