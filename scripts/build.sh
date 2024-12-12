#!/bin/bash

# Directory setup
POSTS_DIR="/build/posts"
BUILD_DIR="/build/blog"
mkdir -p "$BUILD_DIR"

echo "Building blog..."

# Start generating the index page (blog.html)
cat > "/build/blog.html" << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Blog - Hello from Fly</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tachyons/4.12.0/tachyons.min.css">
  </head>
  <body class="sans-serif bg-light-gray">
    <div class="flex flex-column min-vh-100">
      <header class="w-100 flex flex-column items-center pv4">
        <h1 class="f2 fw9 blue">Blog Posts</h1>
        <nav class="flex items-center">
          <a class="link blue hover-dark-blue mh3" href="/">Home</a>
          <a class="link blue hover-dark-blue mh3" href="/blog.html">Blog</a>
          <a class="link blue hover-dark-blue mh3" href="/goodbye.html">Goodbye</a>
        </nav>
      </header>

      <main class="flex-auto">
        <div class="flex flex-column items-center ph3">
          <!-- Posts will be inserted here -->
EOF

# Process each markdown file in reverse chronological order
for file in $(ls -r $POSTS_DIR/*.md); do
    filename=$(basename "$file")
    date=${filename:0:10}
    name=${filename:11:-3}
    title=$(head -n 1 "$file" | sed 's/# //')
    
    echo "Processing: $filename"
    
    # Extract first paragraph as excerpt (after the title)
    excerpt=$(sed '1d' "$file" | awk '/^$/ { if (p) { exit }; p=1; next } p { print }' | head -n 1)
    
    # Create individual post HTML
    cat > "$BUILD_DIR/${name}.html" << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>${title} - Blog</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tachyons/4.12.0/tachyons.min.css">
  </head>
  <body class="sans-serif bg-light-gray">
    <div class="flex flex-column min-vh-100">
      <header class="w-100 flex flex-column items-center pv4">
        <nav class="flex items-center">
          <a class="link blue hover-dark-blue mh3" href="/">Home</a>
          <a class="link blue hover-dark-blue mh3" href="/blog.html">Blog</a>
          <a class="link blue hover-dark-blue mh3" href="/goodbye.html">Goodbye</a>
        </nav>
      </header>

      <main class="flex-auto">
        <article class="flex flex-column items-center ph3">
          <div class="w-100 mw7 bg-white pa4 br3 shadow-4">
            <h1 class="f2 fw9 mt0 blue">${title}</h1>
            <div class="f6 gray mb4">${date}</div>
            <div class="lh-copy">
              $(pandoc "$file")
            </div>
            <a href="/blog.html" class="link blue hover-dark-blue">← Back to all posts</a>
          </div>
        </article>
      </main>
    </div>
  </body>
</html>
EOF
    
    # Add entry to index page
    cat >> "/build/blog.html" << EOF
          <article class="w-100 mw7 bg-white mb4 br3 pa4 shadow-4">
            <h2 class="f3 fw7 mt0"><a class="link blue hover-dark-blue" href="/blog/${name}.html">${title}</a></h2>
            <div class="f6 gray mb3">${date}</div>
            <p class="lh-copy">${excerpt}</p>
          </article>
EOF
done

# Close the index page
cat >> "/build/blog.html" << EOF
        </div>
      </main>
    </div>
  </body>
</html>
EOF

echo "Build complete!"