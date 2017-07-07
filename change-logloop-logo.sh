docker cp defaults.js elk5-cntr:/opt/kibana/src/ui/settings
docker cp chrome.jade elk5-cntr:/opt/kibana/src/ui/views
docker cp ui_app.jade elk5-cntr:/opt/kibana/src/ui/views
docker cp commons.style.css elk5-cntr:/opt/kibana/optimize/bundles
docker cp kibanaWelcomeLogo.svg elk5-cntr:/opt/kibana/optimize/bundles
docker cp logloop-logo.svg elk5-cntr:/opt/kibana/optimize/bundles