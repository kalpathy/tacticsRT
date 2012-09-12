# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tactics_session',
  :secret      => '75edf52a4a04620ecdf4b04373bf53c55fb1b536a81433b2269496bb6d192fddf912508bf4026baca39e1247a36f468c8608ed9114b614768e0849bdac026619'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
