provider "aws" {
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
