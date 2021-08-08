module ExeLib

  def exe(cmd, dir: nil)
    cd_cmd = "cd #{dir} && " if dir
    cmd = "#{cd_cmd}#{cmd}"
    puts "executing: #{cmd}"
    out = system cmd
    puts out
    out
  end

  def r_exe(cmd, dir: nil)
    cd_cmd = "cd #{dir} && " if dir
    cmd = "#{cd_cmd}#{cmd}"
    puts "executing: #{cmd}"
    out = `#{cmd}`
    puts out
    out
  end

end
