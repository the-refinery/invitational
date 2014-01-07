namespace :invitational do
  desc "Creates an Uberadmin User"
  task :create_uberadmin => [:environment] do
    email = Digest::SHA1.hexdigest(DateTime.now.to_s) + "@localhost"

    creator = Invitational::CreatesUberAdminInvitation.for email
    invitation = creator.invitation

    puts "Your uberadmin invitation claim hash is: #{invitation.claim_hash}"
    puts "Visit your claim URL with this hash to claim the invitation."
  end
end
