# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
# pin "html5-qrcode", to: "https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js" # @2.3.8
pin "@zxing/library", to: "https://ga.jspm.io/npm:@zxing/library@0.20.0/esm/index.js" # @0.21.3
pin "ts-custom-error" # @3.3.1
