# push new version of app
echo "Pushing new version of app to green"
cf push marktodo-temp -n mark-todo-temp

# load balanced between
echo "Map original route to green (load balanced)"
cf map-route marktodo-temp mybluemix.net -n marktodo

# unmap original route
echo "Unmap original route"
cf unmap-route marktodo mybluemix.net -n marktodo

# remove temp route
echo "Remove green temp route"
cf unmap-route marktodo-temp mybluemix.net -n mark-todo-temp

# delete app
echo "Delete original (blue) app"
cf delete marktodo

# rename app
echo "Rename (green to blue)"
cf rename marktodo-temp marktodo
