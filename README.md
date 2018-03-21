In ec2-instance.tf

  access_key = "place your AWS key here"
  secret_key = "place your AWS secret key here"
    Name =  "Tag as anything you want your EC2 instance to be tagged"


You'll need to add this section for your html/css files here.   These are just examples.  I added my own files for html and css to make the page look nice. 

E.g:

provisioner "file" {
    source = "./index.html"
    destination = "C:/Project/index.html"
    }
    provisioner "file" {
    source = "./background.png"
    destination = "C:/Project/background.png"
    }
    
So to be clear, you need to add your own index.html and other css files in your terraform dir


In Terraform.tfvars you need to add your information from AWS:

KEY_NAME = "your PEM file name"
SECURITY_GROUP = ["your AWS Security group"]
IAM_INSTANCE_PROFILE = "Your IAM profile in AWS"
SUBNET_ID = "Your subnet ID in AWS"
INSTANCE_USERNAME = "Windows Uname"
INSTANCE_PASSWORD = "Windows Password"


The variables.tf file can remain the same.

Once you enter the proper values in the above files, add at least an index.html file, this should show your web page and contents of index.html on the IP address AWS generates.  

Remember:
terraform init
terraform plan
terraform apply

Please email me at mraval818@gmail.com for any questions.   


