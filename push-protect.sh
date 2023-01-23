TEMP_BRANCH="push-protect/$RANDOM-$RANDOM-$RANDOM"
echo "Pushing the current commit to a temporary branch: $TEMP_BRANCH"
git checkout -b $TEMP_BRANCH
git push -u origin $TEMP_BRANCH
git checkout main
WAIT_UNTIL=$((`date +%s` + 600))
while [ true ]
do
  echo "Sleeping for 30 seconds"
  sleep 30
  echo "Attempting to push to main"
  if git push origin main; then
    echo "Push is successful"
    git push origin --delete $TEMP_BRANCH
    exit 0
  else
    echo "Push to main still failed."
    CUR_TIME=$((`date +%s`))
    if [ $CUR_TIME -gt $WAIT_UNTIL ]
    then
      echo "Already waited for 600 seconds and still can't push. Exiting with error."
      git push origin --delete $TEMP_BRANCH
      exit 1
    fi
  fi
done