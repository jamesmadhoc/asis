# frozen_string_literal: true

require 'csv'
namespace :oasis do
  desc 'Create initial batch of Flickr & MRSS profiles from CSV files'
  task seed_profiles: :environment do
    CSV.foreach("#{Rails.root}/config/flickr_profiles.csv") do |row|
      flickr_profile = FlickrProfile.new(name: row[2], id: row[1], profile_type: row[0])
      flickr_profile.save && FlickrPhotosImporter.perform_async(flickr_profile.id, flickr_profile.profile_type)
    end
    CSV.foreach("#{Rails.root}/config/mrss_profiles.csv") do |row|
      mrss_profile = MrssProfile.new(id: row[0])
      mrss_profile.save && MrssPhotosImporter.perform_async(mrss_profile.name)
    end
  end
end
