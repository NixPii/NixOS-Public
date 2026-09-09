# Originally only a Neovim setup, now contains development enviroment setup. Change made on:  (Y|M|D) 26.07.17
{
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.nvf = {
    enable = true;
    settings = {
      # -----------------------------------------------------------
      # General Options & Leaders
      # -----------------------------------------------------------

      vim.viAlias = true;
      vim.vimAlias = true;
      vim.globals.mapleader = " ";

      vim.options = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
        smartindent = true;
        undofile = true;
        cursorline = true;
        mouse = "a";
        termguicolors = true;
      };

      # -----------------------------------------------------------
      # Theme
      # -----------------------------------------------------------
      vim.theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };

      # -----------------------------------------------------------
      # UI & Specialized Tools
      # -----------------------------------------------------------
      vim.statusline.lualine.enable = true;
      vim.formatter.conform-nvim.enable = true;
      vim.telescope.enable = true;
      vim.autocomplete.nvim-cmp.enable = true;
      vim.dashboard.alpha.enable = true;
      vim.ui.noice.enable = true;
      vim.ui.colorizer.enable = true;
      vim.notify.nvim-notify.enable = true;
      vim.visuals.indent-blankline.enable = true;
      vim.utility.oil-nvim.enable = false;
      vim.utility.yazi-nvim.enable = true;

      # Additional utility plugins
      vim.git = {
        gitsigns.enable = true;
        vim-fugitive.enable = true;
      };
      vim.comments.comment-nvim.enable = true;

      # -----------------------------------------------------------
      # Treesitter & LSP
      # -----------------------------------------------------------
      vim.treesitter = {
        enable = true;
        autotagHtml = true;
        highlight.enable = true;
        indent.enable = true;
      };

      vim.lsp = {
        enable = true;
        null-ls.enable = false;
        formatOnSave = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        presets.nixd.enable = true; # Remember to install nixd, and other LSP servers
        presets.gopls.enable = true;

        servers = {
          # Force nixd to ONLY run on Nix files
          nixd = {
            filetypes = ["nix"];
            settings = {
              nixd = {
                nixpkgs = {
                  expr = ''(builtins.getFlake "/home/nixpii/.nixos").nixosConfigurations.nixie.pkgs'';
                };
                options = {
                  main = {
                    expr = ''let f = builtins.getFlake "/home/nixpii/.nixos"; n = f.nixosConfigurations.nixie.options; h = n.home-manager.users.type.getSubOptions []; in f.nixosConfigurations.nixie.pkgs.lib.recursiveUpdateUntil (_: l: r: (l._type or null) == "option" || (r._type or null) == "option") n h'';
                  };

                  #nixos = {
                  #  expr = ''builtins.removeAttrs (builtins.getFlake "/home/nixpii/.nixos").nixosConfigurations.nixie.options [ "catppuccin" ]''; # ''(builtins.getFlake "/home/nixpii/.nixos").nixosConfigurations.nixie.options'';
                  #};
                  #home-manager = {
                  #  expr = ''(builtins.getFlake "/home/nixpii/.nixos").nixosConfigurations.nixie.options.home-manager.users.type.getSubOptions []''; # ''(builtins.getFlake "/home/nixpii/.nixos").nixosConfigurations.nixie.options.home-manager.users.type.getSubOptions []'';
                };
              };
            };
          };
          #};

          # Force gopls to ONLY run on Go files, and pass settings
          gopls = {
            filetypes = ["go" "gomod" "gowork" "gotmpl"];
            settings = {
              gopls = {
                completeUnimported = true;
                usePlaceholders = true;
                analyses = {
                  unusedparams = true;
                  shadow = true;
                };
                staticcheck = true;
                hints = {
                  assignVariableTypes = true;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = true;
                  constantValues = true;
                  functionTypeParameters = true;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
              };
            };
          };
        };
      };

      # -----------------------------------------------------------
      # Languages
      # -----------------------------------------------------------

      vim.languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        # Nix
        nix.enable = true;
        nix.format.enable = true;

        # Python
        python = {
          enable = true;
          lsp.servers = ["basedpyright"];
        };

        go = {
          enable = true;
          lsp.enable = true;
          lsp.servers = ["gopls"];
          treesitter.enable = true;

          format = {
            enable = true;
            type = ["gofumpt"];
          };
        };

        # Bash
        bash = {
          enable = true;
          format.enable = true;
          format.type = ["shfmt"];
        };

        # Java is a pain in the ass, but Minecraft. Need i say more?
        java = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };

        # Press X to Jason (https://youtu.be/OYQDnV092hI?si=GB3_602vz1NR9g1-)
        json.enable = true;

        # WE LOVE RUBY, RUBY IS LOVE, THIS IS SPONSORED BY RUBY PROPAGANDA
        ruby = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };

        # Linux kernel devtools, rust and such
        rust = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        assembly.enable = true;

        # Website creation
        html.enable = true;
        css.enable = true;
        # typescript.enable = true; # TEMPORARILY DISABLED UNTIL UPSTREAM FIXES
        markdown.enable = true;

        # Other BS
        lua.enable = true; # LUA
        yaml.enable = true; # YAML
      };

      # -----------------------------------------------------------
      # Terminal & Custom Lua
      # > Be me
      # > Lazy as fuck
      # > ishouldredothis.jpeg
      # -----------------------------------------------------------
      # nvf uses luaConfigRC as an attribute set for DAG-based config chunks.
      vim.luaConfigRC.terminalLogic = ''
        local function term_in_split(direction, size)
          -- Move back to the previous window before splitting
          vim.cmd('wincmd p')
          if direction == 'botright' then
            vim.cmd((size or 15) .. 'split')
          elseif direction == 'rightbelow' then
            vim.cmd((size or 60) .. 'vsplit')
          else
            vim.cmd('split')
          end
          vim.cmd('terminal')
          vim.cmd('startinsert')
        end

        -- Make it globally accessible for keymaps
        _G.term_in_split = term_in_split
      '';

      # -----------------------------------------------------------
      # Keymaps (Legacy, i should redo this  :D)
      # -----------------------------------------------------------
      vim.keymaps = [
        # Terminal Keymaps
        {
          key = "<leader>tt";
          mode = "n";
          action = ":lua _G.term_in_split('botright', 15)<CR>";
          silent = true;
          desc = "Terminal (bottom)";
        }
        {
          key = "<leader>tv";
          mode = "n";
          action = ":lua _G.term_in_split('rightbelow', 60)<CR>";
          silent = true;
          desc = "Terminal (right)";
        }
        {
          key = "<Esc>";
          mode = "t";
          action = "<C-\\><C-n>";
          desc = "Exit Terminal Insert Mode";
        }

        # Ease of life
        {
          key = "<leader>w";
          mode = "n";
          action = ":w<CR>";
          desc = "Save";
        }
        {
          key = "<leader>e";
          mode = "n";
          action = "<cmd>Oil<cr>";
          desc = "File Explorer";
        }

        # Window navigation from terminal
        {
          key = "<C-h>";
          mode = "t";
          action = "<C-\\><C-n><C-w>h";
        }
        {
          key = "<C-j>";
          mode = "t";
          action = "<C-\\><C-n><C-w>j";
        }
        {
          key = "<C-k>";
          mode = "t";
          action = "<C-\\><C-n><C-w>k";
        }
        {
          key = "<C-l>";
          mode = "t";
          action = "<C-\\><C-n><C-w>l";
        }
      ];
    };
  };

  # --- Dev Packages ---
  environment.systemPackages = with pkgs; [
    jujutsu
    git
    docker-compose
    vscode
    kdePackages.kate
    fetch #  I mean c'mon, we got to show off
    godot
  ];

  # --- Docker ---
  virtualisation.docker = {
    enable = true;
    daemon.settings = {"firewall-backend" = "nftables";};
  };
  systemd.services.docker.path = [
    pkgs.nftables
  ];
}
