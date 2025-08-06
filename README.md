# markdown_image_clean.nvim

一个用于清理 Markdown 文件中未引用图片的 Neovim 插件。

## ✨ 功能特性

- 🔍 **智能分析**: 扫描当前目录下的所有 Markdown 文件，提取图片引用
- 🗑️ **安全清理**: 识别并删除未被引用的图片文件
- 🎛️ **灵活配置**: 支持自定义图片目录、文件扩展名等配置
- ⌨️ **快捷键支持**: 提供便捷的键盘映射
- 🛡️ **安全确认**: 删除前提示用户确认

## 📦 安装

### 使用 [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'your-username/markdown_image_clean.nvim',
  config = function()
    require('markdown_image_clean').setup({
      -- 可选配置
    })
  end,
}
```

### 使用 [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'your-username/markdown_image_clean.nvim',
  config = function()
    require('markdown_image_clean').setup()
  end
}
```

### 使用 [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'your-username/markdown_image_clean.nvim'
```

然后在你的 `init.lua` 中添加：

```lua
require('markdown_image_clean').setup()
```

## 🚀 使用方法

### 命令

#### `:MarkdownImageAnalyze [图片目录]`
分析当前目录下的 Markdown 文件，显示图片引用情况。

```vim
" 使用默认图片目录 (imgs)
:MarkdownImageAnalyze

" 指定图片目录
:MarkdownImageAnalyze assets/images
```

#### `:MarkdownImageClean [图片目录]`
清理未引用的图片文件。

```vim
" 使用默认图片目录
:MarkdownImageClean

" 指定图片目录
:MarkdownImageClean assets/images
```

### 快捷键

默认键映射：

- `<leader>mia`: 分析图片引用情况
- `<leader>mic`: 清理未引用的图片

### Lua API

```lua
local markdown_image_clean = require('markdown_image_clean')

-- 分析图片引用
markdown_image_clean.analyze_images('imgs')

-- 清理未引用的图片
markdown_image_clean.clean_images('imgs')
```

## ⚙️ 配置

### 默认配置

```lua
require('markdown_image_clean').setup({
  -- 默认图片目录
  default_image_dir = 'imgs',
  
  -- 是否显示详细信息
  verbose = true,
  
  -- 支持的图片文件扩展名
  image_extensions = { 'png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'bmp', 'tiff' },
  
  -- 是否在删除前确认
  confirm_delete = true,
  
  -- 键映射配置
  keymaps = {
    analyze = '<leader>mia',  -- 分析图片引用
    clean = '<leader>mic',    -- 清理未引用的图片
  },
  
  -- 是否启用默认键映射
  enable_default_keymaps = true,
  
  -- 删除文件时是否显示进度
  show_progress = true,
  
  -- 是否在分析后自动显示结果窗口
  auto_show_results = true,
})
```

### 自定义配置示例

```lua
require('markdown_image_clean').setup({
  -- 使用不同的图片目录
  default_image_dir = 'assets/images',
  
  -- 禁用详细输出
  verbose = false,
  
  -- 添加更多支持的图片格式
  image_extensions = { 'png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'avif' },
  
  -- 不需要确认直接删除（谨慎使用）
  confirm_delete = false,
  
  -- 自定义键映射
  keymaps = {
    analyze = '<leader>ia',
    clean = '<leader>ic',
  },
})
```

## 🔧 工作原理

1. **扫描 Markdown 文件**: 插件会扫描当前工作目录下的所有 `.md` 文件
2. **提取图片引用**: 使用正则表达式提取以下格式的图片引用：
   - Markdown 语法: `![alt text](image_path)`
   - HTML 语法: `<img src="image_path">`
3. **检查图片文件**: 扫描指定图片目录中的所有图片文件
4. **对比分析**: 找出未被任何 Markdown 文件引用的图片
5. **安全删除**: 在用户确认后删除未引用的图片文件

## 📁 支持的文件格式

- **Markdown 文件**: `.md`
- **图片文件**: `png`, `jpg`, `jpeg`, `gif`, `svg`, `webp`, `bmp`, `tiff`

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🙏 致谢

这个插件的灵感来源于清理 Markdown 文档中冗余图片的实际需求。
