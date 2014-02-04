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
    sound { fixture_file_upload(Rails.root.join("spec", "songs", "test.mp3"), "audio/mp3") }
    
  end

end
