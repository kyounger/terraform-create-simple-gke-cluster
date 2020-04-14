# Requirements
## Adding gcloud auth
I'm using GCP, so this is my documentation on how to create a service acount for my purposes. I store this is `./creds`. Yours may be different based on how you authenticate for your cloud provider in the TF. This dir is ignored by git.

```
CURRENT_PROJECT=$(gcloud config get-value core/project 2>/dev/null)
SA_NAME="maintf"

gcloud iam service-accounts create $SA_NAME
gcloud projects add-iam-policy-binding $CURRENT_PROJECT --member "serviceAccount:$SA_NAME@$CURRENT_PROJECT.iam.gserviceaccount.com" --role "roles/owner"
gcloud iam service-accounts keys create ./creds/key.json --iam-account=$SA_NAME@$CURRENT_PROJECT.iam.gserviceaccount.com
```

## CloudBees licenses
I store a copy of my license key/cert in `./license`. This dir is ignored by git.

## Create initial empty dir
Be sure to run `mkdir repo-100` in the room of this repo before running `./new-instance.sh`
