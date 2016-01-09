exports.config =
  # See http://brunch.io/#documentation for docs.
  files:
    javascripts: joinTo: "js/app.js"
    stylesheets: joinTo: "css/app.css"
    templates: joinTo: "js/app.js"

  conventions: assets: /^(web\/static\/assets)/

  paths:
    # Dependencies and current project directories to watch
    watched: [
      "web/static"
      "test/static"
    ]
    # Where to compile files to
    public: "priv/static"

  plugins:
    babel:
      # Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    afterBrunch: ["mkdir -p priv/static/fonts", "cp -f bower_components/font-awesome/fonts/* priv/static/fonts/"]

  modules:
    autoRequire:
      "js/app.js": ["web/static/js/app"]
      "js\\app.js": ["web/static/js/app"]

  npm:
    enabled: true,
    whitelist: ["phoenix", "phoenix_html"]
