def identify_shopify_env!
  shopify_env_file_path = File.expand_path("~/.shopify-env")
  not_shopify_env_file_path = File.expand_path("~/.not-shopify-env")

  return if File.exist?(shopify_env_file_path) || File.exist?(not_shopify_env_file_path)

  shopify_env = nil

  while shopify_env.nil?
    puts "Is this a Shopify machine? y/n"
    shopify_env = gets
  end

  if ['y', 'Y'].include?(shopify_env)
    puts `touch #{shopify_env_file_path}`
  else
    puts `touch #{not_shopify_env_file_path}`
  end
end

puts "Setting up your environment..."

identify_shopify_env!

instructions = <<~TEXT
  0. Clone this repo to ~/nixfiles (elsewhere is OK too, but there are a couple aliases that expect ~/nixfiles)
  1. Install Nix: https://nixos.org/download.html#download-nix
  3. Install Nix home-manager: https://nix-community.github.io/home-manager/index.html#ch-installation
  4. Install nvm: https://github.com/nvm-sh/nvm#install--update-script

  ## Mac only

  1. Install Homebrew (Mac-only): https://brew.sh
  2. Use Homebrew to install the Brewfile linked at `% brew bundle --file ~/.Brewfile` to install GUI apps
TEXT

