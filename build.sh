# rm -r content/*
mkdir -p content/posts
rm -r public/*
rm -r content/posts/*
obsidian-export ../Blog/ content/posts/ --frontmatter always
git add .
git commit -m "Auto Commit"
git push