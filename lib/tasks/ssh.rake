module RemoteAccess
  def ssh_cmd(cmd, host)
    sh 'ssh', '-F', ENV['CHAKE_SSH_CONFIG'], host, cmd
  end

  def scp_cmd(file, dest, host, flags='')
    sh 'scp', flags,'-F', ENV['CHAKE_SSH_CONFIG'], file, "#{host}:#{dest}"
  end
end
