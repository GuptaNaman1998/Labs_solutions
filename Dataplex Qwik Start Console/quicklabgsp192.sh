gcloud services enable \
  dataplex.googleapis.com 
 
export PROJECT_ID=$(gcloud config get-value project)

export REGION=europe-west1
gcloud config set compute/region $REGION

gsutil mb -l $REGION gs://$PROJECT_ID

gcloud dataplex lakes create sensors \
   --location=$REGION \
   --display-name="sensors" \
   --description="sensors Domain"
   
gcloud dataplex zones create temperature-raw-data \
    --location=$REGION \
    --lake=sensors \
    --display-name="temperature raw data" \
    --resource-location-type=SINGLE_REGION \
    --type=RAW \
    --discovery-enabled \
    --discovery-schedule="0 * * * *"

gcloud dataplex assets create measurements \
--location=$REGION \
--lake=sensors \
--zone=temperature-raw-data \
--display-name="measurements" \
--resource-type=STORAGE_BUCKET \
--resource-name=projects/$PROJECT_ID/buckets/$PROJECT_ID \
--discovery-enabled 

gcloud dataplex assets delete measurements --location=$REGION --zone=temperature-raw-data --lake=sensors 

gcloud dataplex zones delete temperature-raw-data --location=$REGION --lake=sensors

gcloud dataplex lakes delete sensors --location=$REGION