# Ensuring_Quality_Releases
Third project in Udacity's Azure devops nanodegree

- This project is completed using Udacity lab which is a shared account amongst
many students
- There is a limitation on the number of build servers per accounts
- To circumvent this limitation, we are using the self-hosted agent.
- Follow this instruction on how to configure it
  https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops
# The details of the project
The project consists of a CI/CD pipeline with four phases.
1. Provisioning
This creates the infrastructure in Azure necessary for the app to run including
the Appservice. This is
done using Terraform
2. Build
This builds the fakerestapi src code and uploads it to Azure
3. Deploy
This downloads the uploaded artifacts and deploys them to Azure Appservice
4. Testing
There are three tests:
- functional testing with Selenium
- Integration tests with Postman
- Performance tests with Jmeter

## Dependencies for local testing
| Dependency | Link |
| ------ | ------ |
| Packer | https://www.packer.io/ |
| Terraform | https://www.terraform.io/downloads.html |
| JMeter |  https://jmeter.apache.org/download_jmeter.cgi|
| Postman | https://www.postman.com/downloads/ |
| Python | https://www.python.org/downloads/ |
| Selenium | https://sites.google.com/a/chromium.org/chromedriver/getting-started |

## Steps

1. Clone this repo:

```sh
git clone https://github.com/usama242/Ensuring_Quality_Releases.git
```

2. Open a Terminal in VS Code and connect to your Azure Account and get the Subscription ID

```bash
az login 
az account list --output table
```

3. Configure storage account to Store Terraform state

* Execute the script **azure-storage-account.sh** :

```bash
./azure-storage-account.sh
```

* Take notes of **storage_account_name**, **container_name**, **access_key** . They are will be used in **main.tf** terrafrom files ( lines 15 to 19)