# rm -r content/*
mkdir -p content/posts
rm -r public/*
rm -r content/posts/*
obsidian-export ../Blog/ content/posts/ --frontmatter always
hugo --minify