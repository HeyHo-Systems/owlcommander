# Enqueue the FetchTwilioDataJob when the worker starts up
Rails.application.config.after_initialize do
  # This fails when run too early (no table to store the job) so it's wrapped in begin rescue
  begin
    FetchTwilioDataJob.perform_later
  rescue ActiveRecord::StatementInvalid => e
    puts "You probably need to run bin/rails db:schema:load"
  end
end