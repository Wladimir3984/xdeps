local exdeps = {}

exdeps.tools = {
               { check = "autopep8", install_command = "pip install autopep8", method = win, desc = "autopep8 for formatting" },
               { check = "prettier", install_command = "npm install --global prettier", method = win, desc = "prettier for formatting" }
              }
exdeps.methods = {
                 windows = function(install)
                   vim.cmd([[!powershell -Command "Start-Process powershell -Verb runAs -ArgumentList ']] .. install .. [['"]])
                 end
                }

function exdeps.check_tools(tools)
  for i, tool in ipairs(tools) do
      local check = tool.check
      local install_command = tool.install_command
      local method = tool.method
      local desc = tool.desc
      -- check if tool is installed
      
      local is_installed = vim.fn.executable(check) == 1
      if not is_installed then -- if not installed, ask user if they want to install it
        local choice = vim.fn.input(desc .. [[ is not installed. do you want to install it?(y/n) > ]])
        if choice:lower() == "y" then
          vim.cmd("redraw!")
          if method == "win" or method == "windows" then
            method = "windows"
          else  
            break
          end
          exdeps.methods[method](install_command)
        end
      end
  end

end

