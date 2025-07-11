# Navigation Enhancement Guide

Quick reference for the new three-layer navigation system in your Neovim configuration.

## 🚀 Quick Reference

### Grapple - Project File Tagging
- `<leader>gt` - Toggle tag on current file
- `<leader>gn` - Jump to next tagged file
- `<leader>gp` - Jump to previous tagged file
- `<leader>gm` - Open tag menu (visual picker)

### Portal - Visual History Navigation
- `<leader>j` - Jump backward through jumplist
- `<leader>J` - Jump forward through jumplist
- `<leader>k` - Navigate backward through changelist
- `<leader>K` - Navigate forward through changelist

### Existing Navigation (unchanged)
- `<leader>sf` - Find files (Telescope)
- `<leader>sg` - Live grep (Telescope)
- `<leader><leader>` - Switch buffers (Telescope)
- `S` - Flash treesitter jump
- `<C-h/j/k/l>` - Navigate vim/tmux panes

## 🎯 Three-Layer Workflow

### 1. Project Level - Grapple Tags
**Use for**: 3-5 most important files you're actively working on

```
Working on a React component:
1. Open src/components/UserProfile.jsx
2. Press <leader>gt to tag it
3. Open src/hooks/useUserData.js
4. Press <leader>gt to tag it
5. Open src/types/user.ts
6. Press <leader>gt to tag it

Now use <leader>gn and <leader>gp to cycle between these key files!
```

### 2. File Discovery - Telescope
**Use for**: Finding files you haven't tagged yet

```
Looking for a specific file:
- <leader>sf - Find files by name
- <leader>sg - Search for text across files
- <leader>sr - Resume last search
```

### 3. Location History - Portal
**Use for**: Navigating through your editing history with visual context

```
Following a debugging trail:
1. Start in main.js
2. Go to definition (gd) → lands in utils.js
3. Go to definition (gd) → lands in config.js
4. Go to definition (gd) → lands in constants.js
5. Press <leader>j to see visual jumplist
6. Select where you want to go back to
```

## 📋 Common Workflows

### Starting a New Feature
```
1. Use <leader>sf to find the main file you'll edit
2. Press <leader>gt to tag it
3. Follow references/definitions to find related files
4. Tag the 2-3 most important ones with <leader>gt
5. Use <leader>gn/<leader>gp to cycle between them as you work
```

### Debugging/Investigation
```
1. Start at the bug location
2. Use LSP navigation (gd, gr, gI) to follow the code
3. Use <leader>j to see your investigation path visually
4. Jump back to important points in your investigation
5. Tag key files you discover with <leader>gt
```

### Context Switching
```
Each git repository has separate Grapple tags:
- Project A: Your 3-5 tagged files
- Project B: Different set of 3-5 tagged files
- Use <leader>j to remember where you left off
```

### Refactoring Sessions
```
1. Tag files you're refactoring with <leader>gt
2. Make changes across multiple files
3. Use <leader>k to navigate through your change history
4. Jump back to see what you changed where
```

## 💡 Pro Tips

### Grapple Best Practices
- **Keep it focused**: Only tag 3-5 files per project
- **Tag workflow files**: Main component, its test, related hook/util
- **Use the menu**: `<leader>gm` shows all tags with file previews
- **Git-scoped**: Tags are per-repository, perfect for project switching

### Portal Best Practices
- **Visual selection**: Portal shows you context, not just file names
- **Jumplist**: Use `<leader>j` after following multiple gd/gr commands
- **Changelist**: Use `<leader>k` to see where you made recent edits
- **Combined power**: Use both together - jump to location, then see recent changes

### Integration Tips
- **Start broad**: Use `<leader>sf` to find files
- **Tag frequently**: Press `<leader>gt` on important files immediately
- **Navigate visually**: Use `<leader>j` instead of `<C-o>` for better context
- **Follow the flow**: gd → gd → gd → `<leader>j` → select destination

## 🔍 Troubleshooting

### Grapple Issues
- **Tags not persisting**: Make sure you're in a git repository
- **No tags showing**: Use `<leader>gm` to see if any files are tagged
- **Can't cycle**: Need at least 2 tagged files for `<leader>gn`/`<leader>gp`

### Portal Issues
- **Empty jumplist**: Make some jumps first (gd, `<C-o>`, etc.)
- **No changes**: Portal changelist needs recent edits in current session
- **Too many results**: Portal limits to 10 entries for performance

### General Tips
- **Learn gradually**: Start with just `<leader>gt` and `<leader>j`
- **Build habits**: Tag files as soon as you know they're important
- **Visual feedback**: Portal shows you where you've been, not just where you can go
- **Muscle memory**: Use these instead of switching to file explorer

## 🎉 Getting Started

1. **Week 1**: Just use `<leader>gt` to tag important files and `<leader>gn`/`<leader>gp` to cycle
2. **Week 2**: Add `<leader>j` when you get lost following code references
3. **Week 3**: Use `<leader>k` to navigate through your recent changes
4. **Week 4**: Combine all three layers for maximum efficiency

Remember: This enhances your existing workflow - Telescope, Flash, and tmux navigation all work exactly the same!