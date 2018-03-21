#####################################################################
# provider
#####################################################################

provider "aws" {
  access_key = "place your AWS key here"
  secret_key = "place your AWS secret key here"
  region     = "us-west-1"
}


#####################################################################
# ec2 web server resource
#####################################################################

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "description"
    values = ["Microsoft Windows Server 2012 R2 RTM 64-bit Locale English AMI provided by Amazon"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["801119661308"] # Canonical
}

resource "aws_instance" "baseline-ami" {
  ami = "${data.aws_ami.windows.id}"
  instance_type = "${var.INSTANCE_TYPE}"
  key_name = "${var.KEY_NAME}"
  security_groups = "${var.SECURITY_GROUP}"
  iam_instance_profile = "${var.IAM_INSTANCE_PROFILE}"
  associate_public_ip_address = "true"
  subnet_id = "${var.SUBNET_ID}"
  tags {
    Name =  "Tag as anything you want your EC2 instance to be tagged"
  }
  user_data = <<EOF
  <powershell>
    net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD} /add
    net localgroup administrators ${var.INSTANCE_USERNAME} /add

    winrm quickconfig -q
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'

    netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow

    net stop winrm
    sc.exe config winrm start=auto
    net start winrm
    mkdir C:\Project

    Start-Process powershell -Verb runAs  
    Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools    
    Import-Module WebAdministration
    Get-WebSite -Name "Default Web Site" | Remove-WebSite -Confirm:$false -Verbose
    New-Website -Name manish -ApplicationPool DefaultAppPool -IPAddress * -PhysicalPath C:\Project -Port 80
    iisreset
  </powershell>
  EOF
  
  provisioner "file" {
    source = "./index.html"
    destination = "C:/Project/index.html"
    }
    provisioner "file" {
    source = "./background.png"
    destination = "C:/Project/background.png"
    }
    
  connection {
    type = "winrm"
    user = "${var.INSTANCE_USERNAME}"
    password = "${var.INSTANCE_PASSWORD}"
    }
}

output "Instance IP" {
  value = "${aws_instance.baseline-ami.public_ip}"
}

output "Instance ID" {
  value = "${aws_instance.baseline-ami.id}"
}