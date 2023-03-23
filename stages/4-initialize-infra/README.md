# Initialize infrastructure

This stage will create all resources that have been use by Application:

* Private Standard GKE with Share-VPC
* Private Bastion Host with IAP Tunnel
* Artifact Registry to store Container Image
* A Service Account have limit permission to GCP Services

## How it works

This stage will be done:

* Create Private GKE with ShareVPC into Host Project.
* Create Service Account for each workload into GKE and grant enough permission to access service on GCP
* Create Dedicated Bastion Host for private connection to Service on GCP.
## How to run this stage

This stage has been designed to work on newly created Control Plane Infrastructure. Four steps are needed to bring up
this stage:

* An DevOps member self-assigns the required roles listed below
* The same administrator runs the first init/apply sequence passing a special variable to apply
* The providers configuration file is derived from the Terraform output or linked from the generated file

### Prerequisites

The roles that the DevOps member used in to apply needs to self-grant are:

* Compute Admin (```roles/compute.admin```)
* Project IAM Admin (```roles/resourcemanager.projectIamAdmin```)
* Container Admin (```roles/container.admin```)
* IAM Service Account Admin (```roles/iam.serviceAccountAdmin```)
* Service Usage Admin (```roles/serviceusage.serviceUsageAdmin```)
* Artifact Registry Admin (```roles/artifactregistry.admin```)
* IAP Admin (```roles/iap.admin```)
* IAP Tunnel Resource Accessor (```roles/iap.tunnelResourceAccessor```)
* IAM Workload Identity Pool Admin (```roles/iam.workloadIdentityPoolAdmin```)
* IAM Service Account User (```roles/iam.serviceAccountUser```)

Then, into Control Plane has to enable following service usage apis:
- ```artifactregistry.googleapis.com```
- ```storage.googleapis.com```
- ```stackdriver.googleapis.com```
- ```servicenetworking.googleapis.com```
- ```compute.googleapis.com```
- ```container.googleapis.com```
- ```iap.googleapis.com```
- ```oslogin.googleapis.com```
- ```storage-api.googleapis.com```
- ```iamcredentials.googleapis.com```
- ```serviceusage.googleapis.com```
- ```networkmanagement.googleapis.com```
- ```cloudresourcemanager.googleapis.com```
- ```pubsub.googleapis.com```
#### Configure variables

Create ```terraform.tfvars``` that follow to your needs:

```yaml
region              = "asia-southeast1"
project_id          = "example-dev-cp-0"
devops_group_name   = "example-devops"
organization_domain = "example.com"
```

### Running the stage

Before running init and apply, check your environment so no extra variables that might influence authentication are
present. In general, you should use user application credentials, following these steps for apply:

```bash
$ terraform init
$ terraform apply
```
## Artifact Registry and Private GKE
If you're using Workload Identity to authenticate your GKE cluster to Google Cloud services, you can follow the steps below to allow your GKE cluster to pull images from Artifact Registry without using a service account key file

Make sure the GKE cluster's service account has the necessary permissions to access the Artifact Registry. You can do this by granting the roles/artifactregistry.reader role to the service account.

If your image is in Artifact Registry, your [node pool's service account](https://cloud.google.com/artifact-registry/docs/access-control#gke) needs read access to the repository that contains the image.

Associate the GKE node pool's service account with the Artifact Registry Reader IAM role by running the following command:

```bash
gcloud projects add-iam-policy-binding [PROJECT_ID] \
--member "serviceAccount:[PROJECT_NUMBER]-compute@developer.gserviceaccount.com" \
--role "roles/artifactregistry.reader"
```
or with terraform:
```HCL
resource "google_artifact_registry_repository_iam_member" "repo_iam" {
  provider = google-beta
  location   = "australia-southeast1"
  member     = "serviceAccount:[PROJECT_NUMBER]-compute@developer.gserviceaccount.com"
  project    = [PROJECT_ID]
  repository = [REPOSITORY_ID]
  role       = "roles/artifactregistry.reader"
}
```
Replace **[PROJECT_ID]** with your Google Cloud project ID, and **[PROJECT_NUMBER]** with your Google Cloud project number.