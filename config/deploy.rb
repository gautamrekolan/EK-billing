set :application, "ek-billing"
set :repository,  "git@github.com:esdougherty/EK-billing.git"
set :scm,         :git
set :user,        "passenger"
set :use_sudo,    false

role :web, "96.126.104.191"                          # Your HTTP server, Apache/etc
role :app, "96.126.104.191"                          # This may be the same as your `Web` server
role :db,  "96.126.104.191", :primary => true # This is where Rails migrations will run

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end
end

after 'deploy:update_code', 'bundler:bundle_new_release'