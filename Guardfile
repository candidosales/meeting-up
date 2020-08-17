
guard 'bundler' do
  watch('Gemfile')
end

guard 'rails', :port => 3000 do
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch(%r{config/environments/.+\.rb})
  watch(%r{config/initializers/.+\.rb})
end

guard 'livereload' do
  watch('config/routes.rb')
  watch(%r{app/.+\.(erb|haml|slim)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(app/assets/.+\.css)\.(scss|less)}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end

