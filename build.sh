# rm -r content/*
mkdir -p content/posts
rm -r content/posts/*
obsidian-export ../Blog/Posts/ content/posts/ --frontmatter always
git add .
git commit -m "Auto Commit"
git push
