# Your new code editor.

![ncode 1](https://github.com/user-attachments/assets/7f965663-a54e-4a95-8901-e7c879a1c866)

#### Powers

* _Performance_: Ncode uses only 200mb of RAM.
* _Speed_: Open your projects in milliseconds with no lag.
* _Extensible:_ Easy, effortless customization.

Ncode is based on Neovim and entirely written in Lua.

#### Why use Ncode?

Stop suffering with slow editors! Ncode is simple, lightweight, and incredibly fast. Perfect for everyday coding needs.

#### Who is Ncode for?

Anyone who needs a fast, customizable editor. With thousands of plugins, you can easily set it up, even if you're new to Neovim and Lua. Ncode supports web, mobile, and desktop development.

Ready for a smooth coding experience? Try Ncode today!

# Where it works

- Windows
- Linux
- Mac OS

# Requirements

- Neovim v10+
- Node JS v18+

### Instalation

Just copy and paste into your terminal.

```raw
npx degit to-codando/codeNvim ~/.config/nvim
```

After cloning, open Neovim in the terminal to install the editor's dependencies.

```raw
nvim 
```

Close the terminal and open it again, and you're done. You've completed the installation.

# How to Use

Just press the spacebar on your keyboard, and a panel will appear. In this panel, key combinations are displayed next to a description.

In the image below, simply press the key combination ``space + d + x``` to show linting errors in a panel that makes it easier to fix the issues in your code.

![ncode-xxx](https://github.com/user-attachments/assets/bb603f22-b5fa-4fea-b9b3-a1d9b4fc4b47)

All keymaps follow this logic.

## ZeroTest AI - Geração Inteligente de Código e Testes

### Recursos

O ZeroTest é um plugin de IA integrado ao ncode que oferece:

- 🤖 Geração automática de código
- 🧪 Criação de testes unitários e de integração
- 🌐 Suporte para múltiplas linguagens
- 🔧 Configuração totalmente personalizável

### Configuração Rápida

No arquivo `settings.lua`, configure o ZeroTest:

```lua
zerotest = {
  api = {
    provider = 'claude',
    api_key = os.getenv('CLAUDE_API_KEY')
  },
  ui = {
    preview_width = 220
  }
}
```

### Keymaps Principais

- `<leader>at`: Menu de geração de testes
- `<leader>atu`: Gerar testes unitários
- `<leader>ati`: Gerar testes de integração
- `<leader>ate`: Gerar testes end-to-end
- `<leader>acg`: Geração interativa de código

### Linguagens Suportadas

- JavaScript/TypeScript
- Python
- PHP
- Go
- E mais...

### Requisitos

- Neovim 0.8+
- Chave de API da Claude (Anthropic)

### Personalização

Ajuste templates de prompt, configurações de UI e segurança no `settings.lua`.


