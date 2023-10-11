terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ExamPro"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  #cloud {
  #  organization = "ExamPro"
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}

}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Bahubali An Indian movie!"
  description = <<DESCRIPTION
"Baahubali: The Beginning" is an epic Indian film that explores the rivalry between two royal brothers, Baahubali and Bhallaladeva, in the kingdom of Mahishmati. The movie culminates in a grand war between the brothers, filled with stunning visuals and breathtaking action sequences. This battle not only showcases their physical prowess but also tests their loyalty and morality. The emotional complexity of their conflict adds depth to the spectacle. "Baahubali: The Beginning" is a cinematic masterpiece, blending mythology, history, and fantasy, and it led to a highly successful sequel, solidifying its status as an iconic Indian film franchise.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}