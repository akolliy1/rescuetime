# Test coverage reporters
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
]

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rescuetime'

require 'webmock/rspec'
require 'vcr'
require 'time'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'

  # Put '<RESCUETIME_API_KEY>' so API key is not committed to source control
  config.filter_sensitive_data('<RESCUETIME_API_KEY>') { 'AK' }
end

# HELPER METHODS
# --------------
#
# Collects invalid dates (determined by 'valid' regex) in a report by time and
# returns invalid date count
#
# @param [Array<Hash>] activities array of activity hashes, each with key :date
# @param [Regexp] valid regexp of valid dates ('YYYY-MM-DD' format)
# @return [Integer] invalid date count
def count_invalid_dates(activities, valid)
  activities.collect { |activity| activity[:date] }
    .delete_if { |date| date =~ valid }.count
end
#
# Returns activity keys from an activities array
#
# @param[Array<Hash>] activities
# @return[Array] activity keys
def collect_keys(activities)
  activities.first.keys
end
#
# Collects unique dates from an activities array where activities have a :date
def unique_dates(activities)
  activities.collect { |activity| Time.parse(activity[:date]) }.uniq
end
