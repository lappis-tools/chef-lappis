namespace :package do

  REPREPRO = 'reprepro -b /var/repositories'

  def ssh_cmd(cmd)
    sh 'ssh', '-F', ENV['CHAKE_SSH_CONFIG'], 'repos', cmd
  end

  def scp_cmd(file, dest, flags='')
    sh 'scp', flags,'-F', ENV['CHAKE_SSH_CONFIG'], file, "repos:#{dest}"
  end

  desc 'Upload a package to Debian Repository'
  task :upload, [:package] do |t, args|
    puts 'Starting uploading package...'
    puts args[:package]
    scp_cmd('dist/' + args[:package],'/tmp/dist','-r')
    ssh_cmd(REPREPRO + 'list includedeb jessie /tmp/dist/' + args[:package] )
  end

  desc 'List all packages on Debian Repository'
  task :list do
    puts 'Listing the packages...'
    ssh_cmd(REPREPRO + ' list jessie')
  end
end
