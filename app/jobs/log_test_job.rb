# app/jobs/log_test_job.rb
class LogTestJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Sidekiq is working! The current time is #{Time.now}."
  end
end
