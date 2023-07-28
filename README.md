# Deployment einer Flask-App auf AWS Elastic Beanstalk mit Terraform - Einsteiger

<a href="https://aws.amazon.com" target="_blank" rel="noreferrer"> 
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" alt="aws" width="40" height="40"/> </a>
<a href="https://www.python.org" target="_blank" rel="noreferrer"> 
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a>
<a href="https://flask.palletsprojects.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/pocoo_flask/pocoo_flask-icon.svg" alt="flask" width="40" height="40"/> </a>
<a href="https://git-scm.com/" target="_blank" rel="noreferrer"> 
<img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a>
<a href="https://www.linux.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/linux/linux-original.svg" alt="linux" width="40" height="40"/> </a>
<a href="https://www.nginx.com" target="_blank" rel="noreferrer"> 
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nginx/nginx-original.svg" alt="nginx" width="40" height="40"/> </a>
<a href="https://www.terraform.io/" target="_blank" rel="noreferrer">
<img src="https://www.vectorlogo.zone/logos/terraformio/terraformio-icon.svg" alt="terraform"
width="40" height="40"/> </a>

## Onlinekurs Terraform von Datamics

Dieses Repository ist Teil unseres Online-Kurses für Terraform-Einsteiger. Wir zeigen hier, Wie mit Terraform eine einfache Flask-App in AWS deployt werden kann.
Besuche unseren Kurs auf Udemy für mehr Informationen-

©Copyright Datamics GmbH 2023 [Datamics Website](https://datamics.com)

## Grundlagen der Komponenten

Terraform ist ein Werkzeug zur Konfiguration von Infrastruktur via Code. Es ist ein deklarativer, programmmatischer und portabler Weg zum Erzeugen, Aktualisieren und Zerstören von Infrastruktur.

Es erlaubt uns S3 Buckets, IAM Rollen, EC2 Instanzen und vieles weiteres zu managen. Dabei werden S3-Buckets zum Speichern der App-Dateien eingesetzt. IAM-Rollen werden genutzt, um EC2-Instanzen Berechtigungen zu geben.

Elastic Beanstalk ist ein Service, mit dem Apps in Amazon's Elastic Cloud Compute Service einfach deployt, gemanagt und sklaliert werden können. Dabei speichert Elastic Beanstalk die Environment der Anwendung zusammen mit dem Programmcode in S3-Buckets und führt sie in EC2-Instanzen als Umgebung aus.

## Voraussetzungen

Du benötigst eine IAM-Rolle mit Berechtigungen für S3, EC2 und Elastic Beanstalk. Der von dir in unserem Setup-Video angelegte AWS-Account und Nutzer hat bereits diese Berechtigungen. Weiterhin braucht Terraform für ein erfolgreiches Deployment deine `AWS_ACCESS_KEY_ID` und deinen `AWS_SECRET_ACCESS_KEY`. Diese hast du lokal mit dem AWS CLI bereits gespeichert.
Außerdem brauchen deine Elastic Beanstalk Ressourcen global einzigartige Namen. Der Code dieses Repositories ist an den entsprechenden Stellen kommentiert. Mehr dazu auch in den Videos und dem Kursmaterial zum Projekt. 


## Speichere deinen Terraform Statefile in einem S3 Bucket

Vor dem Deployment musst du einen Bucket für deinen Terraform Statefile in der AWS-Konsole anlegen. Der Name des von dir erstellten Buckets und der Pfad, unter dem der Statefile abgelegt werden soll, definierst du in der Datei `backend.tfvars` unter dem Eintrag `prod` (für Produktion).

```
bucket = "eb-flask-app-statefile"
key    = "statefile/terraform.tfstate"
region = "eu-central-1"
```

Das Speichern des Terraform Statefiles hilft beim Management von Terraform-Operationen, beispielsweise als Backup beim Zerstören einer Infrastruktur. Außerdem wird so das kollaborative Arbeiten an Terraform-Apps ermöglicht.

Mehr Informationen zu S3-Buckets hier in der [AWS S3 Dokumentation](https://docs.aws.amazon.com/AmazonS3/latest/dev/Welcome.html).

## Einzigartiger Bucketname

In `eb_app.tf` wird ein S3-Bucket angelegt, in dem die App von Elastic Beanstalk gespeichert wird. Der Name dieses Buckets muss global einzigartig sein, sonst scheitert das Deployment. Ersetze dazu `jo` durch deinen Vornamen in diesem Ausdruck:

```
resource "aws_s3_bucket" "eb_bucket" {
  bucket = "jo-eb-python-flask" 
}
```


## Solution Stack definieren

Der Solution Stack ist die Softwarearchitektur, auf der deine App ausgeführt werden soll. Diese ist in der Datei `eb_app.tf` definiert: 

```
solution_stack_name = "64bit Amazon Linux 2023 v4.0.2 running Python 3.9"
```

Gelegentlich entfernt Amazon veraltete Solution Stacks. Ein Deployment-Versuch mit einem nicht mehr vorhandenen Solution Stack scheitert. Bei Problemen dieser Art muss der Solution Stack durch eine neue Version ersetzt werden, welche in der [AWS Solution Stack Dokumentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.python) zu finden ist.


## Deployment

Zuerst muss Terraform im Verzeichnis der App initialisiert werden mit diesem Befehl:
```
terraform init
```

Wurde Terraform zuvor bereits initialisiert mit einer anderen Konfiguration, kann es erforderlich sein, die vorherige Initialisierung zu löschen:
```
rm -rf .terraform
```

Nach der erfolgreichen Initialisierung wird die App wie folgt deployt:
```
terraform apply
```

Dabei muss die Rückfrage mit `yes` bestätigt werden.

Verifiziere die App, nachdem das Deployment durchgelaufen ist. Öffne dazu die AWS Elastic Beanstalk Console und anschließend den Link der App unter

[FERTIGSTELLEN NACH DEM NÄCHSTEN DEPLOYMENT!]


[inkl. Website öffnen im Browser über aws console oder aws open]

## Aufräumen

destroy

Inklusive App Bucket löschen