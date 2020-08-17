namespace :lembretes do
  desc 'Task de lembretes para reunião'
  task :run => :environment do
    LembreteEngine.run
  end
end