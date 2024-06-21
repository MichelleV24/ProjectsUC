install.packages("remotes")
install.packages(c("shinylive", "httpuv"))

library(shinylive)
library(rmarkdown)

# Define the path to your Shiny app directory
app_dir <- "."

app_dir

# Render the Shiny app to a static HTML file
shinylive::export(appdir = app_dir, destdir = "docs")

# Serve the static HTML file locally (for testing purposes)
httpuv::runStaticServer("docs/", port = 8008)
