# 测试 Markdown 文件

这是一个用于测试 markdown_image_clean.nvim 插件的示例文件。

## 图片引用示例

### Markdown 语法
![示例图片](imgs/example.png)
![另一个图片](imgs/another.jpg)

### HTML 语法  
<img src="imgs/html_image.gif" alt="HTML 图片">
<img src="imgs/test.svg" width="100">

## 未引用的图片

在 `imgs/` 目录中可能存在一些未被引用的图片文件：
- unused1.png
- unused2.jpg
- old_screenshot.png

这些文件应该会被插件检测到并提示删除。

## 使用方法

1. 在包含此文件的目录中打开 Neovim
2. 运行 `:MarkdownImageAnalyze` 查看分析结果
3. 运行 `:MarkdownImageClean` 清理未引用的图片
4. 或使用快捷键 `<leader>mia` 和 `<leader>mic`
