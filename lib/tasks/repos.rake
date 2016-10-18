#
# All tasks and libs referent to the repos environment are defined here
#

desc 'Display a help for package tasks'
task :package do
  puts 'Task Package - To manage the package from the Lappis Debian Repository'
  puts 'Tasks:'
  puts "\tupload[package,release]\t\tUpload a package. Must to be the full package name. Default release: jessie"
  puts "\tlist[release]\t\t\tList all packages. Default release: jessie"
  puts "\tremove[package,release]\t\tRemove given package. Only the name of the package are needed. Default release: jessie.
    \t\t\t\t\tNote: reprepro doesn't raise a error if the package is not found. Please make sure the package was delete with the list task"
  puts 'Env:'
  puts "\tPKG_DIR\t\tPath to the packages to upload. Default: dist"
end

namespace :package do
  REPREPRO = 'sudo reprepro -b /var/repositories'
  PKG_DIR = ENV['PKG_DIR'] || 'dist'

  def ssh_cmd(cmd)
    sh 'ssh', '-F', ENV['CHAKE_SSH_CONFIG'], 'repos', cmd
  end

  def scp_cmd(file, dest, flags='')
    sh 'scp', flags,'-F', ENV['CHAKE_SSH_CONFIG'], file, "repos:#{dest}"
  end

  desc 'Upload a package to Lappis Debian Repos'
  task :upload, [:package, :release] do |t, args|
    unless args.package
      puts 'Specify the full name of the package.'
      abort
    end
    puts 'Starting uploading package...'
    release = args.release || 'jessie'
    ssh_cmd('rm -rf /tmp/dist')
    scp_cmd(PKG_DIR,'/tmp/dist','-r')
    ssh_cmd("#{REPREPRO} includedeb #{release} /tmp/dist/ #{args.package}")
  end

  desc 'List all packages on Lappis Debian Repos'
  task :list, [:release] do |t, args|
    puts 'Listing the packages...'
    release = args.release || 'jessie'
    ssh_cmd("#{REPREPRO} list #{release}")
  end

  desc 'Remove given package from the Lappis Debian Repos.'
  task :remove, [:package, :release] do |t, args|
    unless args.package
      puts 'Specify the full name of the package.'
      next
    end
    puts 'Removing package'
    release = args.release || 'jessie'
    ssh_cmd("#{REPREPRO} remove #{release} #{args.package}")
  end
end
