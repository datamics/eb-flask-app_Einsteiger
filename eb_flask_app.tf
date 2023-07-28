terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Erforderlich
      version = "~> 3.27"       # Erforderlich
    }
  }
}

# AWS Provider Konfiguration
provider "aws" {
  profile = "default"   # AWS Profil 
  region  = "eu-central-1" # AWS Region
}

# S3 Bucket für das Deployment der Python Flask App erzeugen
resource "aws_s3_bucket" "eb_bucket" {
  bucket = "jo-eb-python-flask" # Der Name dieses S3 Bucket muss global einzigartig sein
}

# App-Dateien für den Upload in S3 definieren
resource "aws_s3_bucket_object" "eb_bucket_obj" {
  bucket = aws_s3_bucket.eb_bucket.id
  key    = "beanstalk/app.zip" # S3 Bucket Pfad zu hochgeladenen App-Dateien
  source = "app.zip"           # Name der App-Datei im Repository für den Upload in S3
}

# Elastic Beanstalk App definieren
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "jo-eb-tf-app"   # Name der Elastic Beanstalk App
  description = "Einfache Flask App" # Beschreibung
}

# Elastic Beanstalk Environment der App und ihre Konfiguration erzeugen
resource "aws_elastic_beanstalk_application_version" "eb_app_ver" {
  bucket      = aws_s3_bucket.eb_bucket.id                    # S3 Bucket Name
  key         = aws_s3_bucket_object.eb_bucket_obj.id         # S3 Key Pfad 
  application = aws_elastic_beanstalk_application.eb_app.name # EB App Name
  name        = "jo-eb-tf-app-version-label"                # Versionslabel der EB App
}

resource "aws_elastic_beanstalk_environment" "tfenv" {
  name                = "jo-eb-tf-env"
  application         = aws_elastic_beanstalk_application.eb_app.name             # EB App Name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.2 running Python 3.9"       # Name des Solution Stack
  description         = "Environment der Flask App"                               # Beschreibung Environment
  version_label       = aws_elastic_beanstalk_application_version.eb_app_ver.name # Versionslabel zuweisen

  setting {
    namespace = "aws:autoscaling:launchconfiguration" # Namespace definieren
    name      = "IamInstanceProfile"                  # Name des Profils
    value     = "aws-elasticbeanstalk-ec2-role"       # Wert definieren
  }
}