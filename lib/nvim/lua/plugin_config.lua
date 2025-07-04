require 'plugin_config/notify'

require 'plugin_config/colorscheme'
require 'plugin_config/lualine'
require 'plugin_config/gitsigns'
require 'plugin_config/cmp'
require 'plugin_config/lsp'
require 'plugin_config/emmet'
require 'plugin_config/ruby'
require 'plugin_config/oil'
require 'plugin_config/tslime'
require 'plugin_config/autopairs'
require 'plugin_config/which_key'
require 'plugin_config/snacks_picker'
require 'plugin_config/conform'
require 'plugin_config/treesitter'
require 'plugin_config/trouble'
require 'plugin_config/twilight'
require 'plugin_config/leap'
require 'plugin_config/json'

if require('helpers').llms_enabled() then
  require 'plugin_config/llms'
end
