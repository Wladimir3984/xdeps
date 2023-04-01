local M = {}

-- Put your externs tools here
M.tools = {
 { check = "python", install_command = nil, method = "win", desc = "python for autopep8" },
  { check = "autopep8", install_command = "pip install autopep8", method = "win", father = "python", desc = "autopep8 for formatting" },
 { check = "node", install_command = nil, method = "win", desc = "node for install prettier" },
  { check = "prettier", install_command = "npm install --global prettier", method = "win", father = "node", desc = "prettier for formatting"},
 { check = "choco", install_command = nil, method = "win", desc = "chocolatey for installing things" },
  { check = "rg", install_command = "choco install ripgrep", method = "win", father = "choco", desc = "ripgrep for telescope" },
  { check = "fzf", install_command = "choco install fzf", method = "win", father = "choco", desc = "fzf for telescope" },
  { check = "mingw32-make", install_command = "choco install mingw", method = "win", father = "choco", desc = "mingw for treesiter on windows" },
          }

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

