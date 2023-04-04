local notify = require("notify")
local M = {}

-- Put your externs tools here
M.tools = {}

M.methods = {
  {method_run = function(install)
                     vim.cmd([[!powershell -Command "Start-Process powershell -Verb runAs -ArgumentList ']] .. install .. [['"]])
                   end,
   method_name = "windows_admin"},
            }

function M.check_tools()
  local all_installed = true
  local msg_auto = "Auto: "
  local msg_non_auto = "Non-auto: "
  local msg_not_installed = "Not installed: "

  for i, tool in ipairs(M.tools) do
      local check = tool.check
      local install_command = tool.install_command
      local method = tool.method
      local father = tool.father
      local desc = tool.desc
      local install_ok = false

      -- check if father tool is installed

      if father then
        local is_father_installed = vim.fn.executable(father) == 1
        if not is_father_installed then -- if not installed, ask user if they want to install it
          notify(father .. [[ is not installed and its important to have it. Install it before you install ]] .. desc, "info", {title = "xdeps"})
          all_installed = false
          msg_not_installed = msg_not_installed .. check .. ", "
          break -- go to next tool
        end
      end

      -- check if tool is installed

      local is_installed = vim.fn.executable(check) == 1
      if not is_installed then -- if not installed, ask user if they want to install it
        local choice = vim.fn.input(desc .. [[ is not installed. do you want to install it?(y/n) > ]])
        if choice:lower() == "y" then
          vim.cmd("redraw!")
          if method and install_command then -- if method is defined, can´t install if method is not available
            for m, m_method in ipairs(M.methods) do
              if m_method.method_name == method then
                m_method.method_run(install_command)
                install_ok = true
                msg_auto = msg_auto .. check .. ", "
              end
            end
          else
            all_installed = false
            msg_not_installed = msg_not_installed .. check .. ", "
            break
          end

        else
          all_installed = false
          msg_not_installed = msg_not_installed .. check .. ", "
        end
      elseif not install_command then -- si esta instalado agregar al checklist de essentials
        msg_non_auto = msg_non_auto .. check .. ", "
      elseif install_command then
        msg_auto = msg_auto .. check .. ", "
      end
      vim.cmd("redraw!")
  end
vim.cmd("redraw!")
notify("Status: [" .. msg_not_installed .. "] [" .. msg_non_auto .. "] [" .. msg_auto .. "].", "info", { title = "xdeps health" })

end

-- only check, return true if all tools are installed and false if not
function M.only_check()
  local all_installed = true
  for _, t in ipairs(M.tools) do
    local is_installed = vim.fn.executable(t.check) == 1
    if not is_installed then
      all_installed = false
      break
    end
  end
  return all_installed
end

return M

