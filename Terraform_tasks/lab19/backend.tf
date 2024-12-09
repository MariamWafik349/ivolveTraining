terraform {
 backend "s3" {
   bucket                  = "my-terraform-state"
   key                     = "NTI.tfstate"
   region                  = "us-east-1"
   dynamodb_table          = "tf-state-db"
  }
}
