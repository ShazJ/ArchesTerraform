terraform {
 backend "gcs" {
   bucket  = "tf-state-store"
   prefix  = "terraform/state"
 }
}
