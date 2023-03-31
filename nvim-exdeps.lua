local exdeps = {}
local tools = {
               { check = autopep8, install_command = "pip install autopep8", method = win, desc = "autopep8 for formatting" },
               { check = prettier, install_command = "npm install --global prettier", method = win, desc = "prettier for formatting" }
              }
local methods = {
                 windows = function(install)
                   vim.cmd([[!powershell -Command "Start-Process powershell -Verb runAs -ArgumentList ']] .. install .. [['"]])
                 end
                }

function exdeps.check_tools(tools)

end

