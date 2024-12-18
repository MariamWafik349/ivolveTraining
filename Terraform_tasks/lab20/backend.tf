terraform {
 backend "s3" {
   bucket                  = "m-tf-statelock"
   key                     = "terraform.tfstate"
   region                  = "us-east-1"
   dynamodb_table          = "tf-state-db"
  }
}
