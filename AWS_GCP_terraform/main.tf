provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}

provider "aws" {
  alias = "db"
  region = var.region

  default_tags {
    tags = {
      terraform = "true"
      projact   = "${var.cluster_name[0]}-project"
    }
  }
}

provider "aws" {
  alias  = "was"
  region = var.region

  default_tags {
    tags = {
      terraform = "true"
      projact   = "${var.cluster_name[1]}-project"
    }
  }
}
