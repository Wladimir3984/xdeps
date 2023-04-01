local M = {}

-- Put your externs tools here
M.tools = {}

M.methods = {
                 windows = function(install)
                   vim.cmd([[!powershell -Command "Start-Process powershell -Verb runAs -ArgumentList ']] .. install .. [['"]])
                 end,
            }

function M.check_tools()
  local all_installed = true
  local msg_auto = "Auto: "
  local msg_non_auto = "Non-auto: "

  for i, tool in ipairs(M.tools) do
      local check = tool.check
      local install_command = tool.install_command
      local method = tool.method
      local father = tool.father
      local desc = tool.desc
      -- check if father tool is installed
      
      if father then
        local is_father_installed = vim.fn.executable(father) == 1
        if not is_father_installed then -- if not installed, ask user if they want to install it
          print(father .. [[ is not installed and its important to have it. Install it before you install ]] .. desc)
          all_installed = false
          break -- go to next tool
        end
      end

      -- check if tool is installed
      
      local is_installed = vim.fn.executable(check) == 1
      if not is_installed then -- if not installed, ask user if they want to install it
        local choice = vim.fn.input(desc .. [[ is not installed. do you want to install it?(y/n) > ]])
        if choice:lower() == "y" then
          vim.cmd("redraw!")
          if method == "win" or method == "windows" then
            method = "windows"
          else  
            all_installed = false
            break
          end
          if install_command then
            M.methods[method](install_command)
            msg_auto = msg_auto .. check .. ", "
          else
            all_installed = false
          end
        else
          all_installed = false
        end
      elseif not install_command then -- si esta instalado agregar al checklist de essentials
        msg_non_auto = msg_non_auto .. check .. ", "
      elseif install_command then
        msg_auto = msg_auto .. check .. ", "
      end
      vim.cmd("redraw!")
  end
if all_installed then
  vim.cmd("redraw!")
  print("All tools are installed. [" .. msg_non_auto .. "] [" .. msg_auto .. "].")
else
  vim.cmd("redraw!")
  print("Some tools aren´t installed(recharge the terminal to check again if you think you installed them)")
end

end

return M

