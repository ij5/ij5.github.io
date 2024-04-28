# rm -r content/*
mkdir -p content/posts
obsidian-export ../Blog/ content/posts/ --frontmatter always
hugo
