# Ensuring_Quality_Releases
Third project in Udacity's Azure devops nanodegree

- This project is completed using Udacity lab which is a shared account amongst
many students
- There is a limitation on the number of build servers per accounts
- To circumvent this limitation, we are using the self-hosted agent.
- Follow this instruction on how to configure it
  https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops

# The details of the project
The project consists of a CI/CD pipeline with three phases.
1. Provisioning
This creates the infrastructure in Azure necessary for the app to run. This is
done using Terraform
2. 