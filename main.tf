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
  cloud {
    organization = "laks_terraform"
    workspaces {
      name = "terra-house-1"
    }
  }

}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_SouthIndianmusic_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.SouthIndianmusic.public_path
  content_version = var.SouthIndianmusic.content_version
}

resource "terratowns_home" "home" {
  name = "SouthIndian music and it's history!"
  description = <<DESCRIPTION
South Indian music, often referred to as "Carnatic music," is a classical music tradition that has its roots in the southern part of India, particularly in the states of Tamil Nadu, Kerala, Karnataka, and Andhra Pradesh. It is one of the two main sub-genres of Indian classical music, with the other being Hindustani music. South Indian music has a rich history and is known for its intricate melodies, rhythmic patterns, and vibrant vocal and instrumental performances.
DESCRIPTION
  domain_name = module.home_SouthIndianmusic_hosting.domain_name
  town = "melomaniac-mansion"
  content_version = var.SouthIndianmusic.content_version
}

module "home_SouthIndianTemples_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.SouthIndianTemples.public_path
  content_version = var.SouthIndianTemples.content_version
}

resource "terratowns_home" "home_SouthIndianTemples" {
  name = "Magnificent SouthIndianTemples"
  description = <<DESCRIPTION
South Indian temple architecture is renowned for its intricate and awe-inspiring designs, which have been a significant part of Indian cultural and religious heritage for centuries. Here are some key characteristics of South Indian temple architecture and a few famous temples known for their architectural brilliance:
DESCRIPTION
  domain_name = module.home_SouthIndianTemples_hosting.domain_name
  town = "the-nomad-pad"
  content_version = var.SouthIndianTemples.content_version
}