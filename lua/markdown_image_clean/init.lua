-- markdown_image_clean.nvim 主模块
local config = require('markdown_image_clean.config')
local M = {}

-- 设置配置
function M.setup(opts)
  config.setup(opts)
end

-- 获取当前工作目录下的所有 markdown 文件
local function get_markdown_files()
  local cwd = vim.fn.getcwd()
  local md_files = {}
  
  -- 使用 vim.fn.glob 查找 .md 文件
  local files = vim.fn.glob(cwd .. '/*.md', false, true)
  
  for _, file in ipairs(files) do
    table.insert(md_files, file)
  end
  
  return md_files
end

-- 从 markdown 内容中提取图片引用
local function extract_image_references(content)
  local references = {}
  
  -- 匹配 Markdown 语法: ![alt](path)
  for path in content:gmatch('!%[.-%]%((.-)%)') do
    if path and path ~= '' then
      local basename = vim.fn.fnamemodify(path, ':t')
      references[basename] = true
    end
  end
  
  -- 匹配 HTML img 标签: <img src="path">
  for path in content:gmatch('<img.-src=["\']([^"\']-)["\']') do
    if path and path ~= '' then
      local basename = vim.fn.fnamemodify(path, ':t')
      references[basename] = true
    end
  end
  
  return references
end

-- 检查文件是否为图片文件
local function is_image_file(filename)
  local ext = vim.fn.fnamemodify(filename, ':e'):lower()
  local cfg = config.get()
  for _, allowed_ext in ipairs(cfg.image_extensions) do
    if ext == allowed_ext then
      return true
    end
  end
  return false
end

-- 获取图片目录中的所有图片文件
local function get_image_files(image_dir)
  local image_files = {}
  
  -- 检查目录是否存在
  if vim.fn.isdirectory(image_dir) == 0 then
    return nil, "图片目录不存在: " .. image_dir
  end
  
  -- 获取目录中的所有文件
  local files = vim.fn.readdir(image_dir)
  
  for _, file in ipairs(files) do
    if is_image_file(file) then
      table.insert(image_files, file)
    end
  end
  
  return image_files, nil
end

-- 分析图片引用情况
function M.analyze_images(image_dir)
  local cfg = config.get()
  image_dir = image_dir or cfg.default_image_dir
  
  -- 转换为绝对路径
  if not vim.startswith(image_dir, '/') then
    image_dir = vim.fn.getcwd() .. '/' .. image_dir
  end
  
  if cfg.verbose then
    print("=== Markdown 图片分析工具 ===")
    print("当前工作目录: " .. vim.fn.getcwd())
    print("图片存放目录: " .. image_dir)
    print("========================\n")
  end
  
  -- 获取所有 markdown 文件
  local md_files = get_markdown_files()
  
  if #md_files == 0 then
    print("错误: 在当前目录中没有找到任何 .md 文件")
    return
  end
  
  -- 分析每个文件，收集图片引用
  local all_references = {}
  
  for _, file in ipairs(md_files) do
    if cfg.verbose then
      print("-> 正在分析文件: " .. vim.fn.fnamemodify(file, ':t'))
    end
    
    local content = table.concat(vim.fn.readfile(file), '\n')
    local references = extract_image_references(content)
    
    for ref, _ in pairs(references) do
      all_references[ref] = true
    end
  end
  
  -- 获取图片目录中的所有图片文件
  local image_files, err = get_image_files(image_dir)
  if err then
    print("错误: " .. err)
    return
  end
  
  if cfg.verbose then
    print(string.format("\n=== 分析结果 ==="))
    print(string.format("分析了 %d 个 Markdown 文件", #md_files))
    print(string.format("找到 %d 个图片引用", vim.tbl_count(all_references)))
    print(string.format("图片目录中有 %d 个图片文件", #image_files))
  end
  
  -- 找出未被引用的图片
  local unused_images = {}
  for _, image in ipairs(image_files) do
    if not all_references[image] then
      table.insert(unused_images, image)
    end
  end
  
  if #unused_images == 0 then
    print("\n✅ 所有图片都被引用了，无需清理")
    return
  end
  
  print(string.format("\n⚠️  找到 %d 个未使用的图片文件:", #unused_images))
  for _, img in ipairs(unused_images) do
    print("  - " .. img)
  end
  
  return unused_images, image_dir
end

-- 清理未引用的图片
function M.clean_images(image_dir)
  local cfg = config.get()
  local unused_images, actual_image_dir = M.analyze_images(image_dir)
  
  if not unused_images or #unused_images == 0 then
    return
  end
  
  -- 确认删除
  if cfg.confirm_delete then
    local choice = vim.fn.input("\n是否要删除这些文件？(y/n): ")
    if choice:lower() ~= 'y' and choice:lower() ~= 'yes' then
      print("已取消删除")
      return
    end
  end
  
  -- 删除文件
  local deleted_count = 0
  for _, img in ipairs(unused_images) do
    local file_path = actual_image_dir .. '/' .. img
    local success = vim.fn.delete(file_path)
    if success == 0 then
      deleted_count = deleted_count + 1
      if cfg.verbose then
        print("✅ 已删除: " .. img)
      end
    else
      print("❌ 删除失败: " .. img)
    end
  end
  
  print(string.format("\n🎉 清理完成！成功删除了 %d 个文件", deleted_count))
end

return M
