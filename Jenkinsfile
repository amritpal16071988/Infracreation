 pipeline {
  agent {
    label "ansible"
  }
  options { disableConcurrentBuilds() }

  parameters {
    choice (name: 'Update', choices: ['false','true'], description: 'parameters update for jenkinsfile')
    credentials (name: 'Credentials', credentialType: 'com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl',description: 'Select your credentials', required: true)
    choice (name: 'Environment', choices: ['dev','qa','uat','prod'],description: 'please select the environment')
    choice (name: 'aws_region', choices: ['us-east-1'], description: 'select region for instance')

  }
  stages {
    stage('Update_Jenkinsparameters') {
      steps {
        script {
          if (env.Update == "true") {
            currentBuild.result = 'ABORTED'
            error("Aborting Pipeline for updating Parameters ..")
          }
        }
      }
    }
    stage('Openstack_tf_creation_plan') {
      steps {
        withCredentials([usernamePassword(credentialsId: "$Credentials", usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        sh '''
          mkdir -p /terraform_state_file/$Environment/
          count=$(ls /terraform_state_file/$Environment/|wc -l)
          cp -r /terraform_state_file/aws_binary/terraform .terraform
          cp /terraform_state_file/aws_binary/terraform.lock.hcl .terraform.lock.hcl
          terraform init
          if [ $count -eq 1 ]
          then
            terraform plan -var Environment=$Environment -var aws_region=$aws_region -state=/terraform_state_file/$Environment/terraform.tfstate
          else
            terraform plan -var Environment=$Environment -var aws_region=$aws_region
          fi
        '''
        }
      }
    }
    stage('Creation_approval') {
	  agent none
	  options {
        timeout( time: 1, unit: 'MINUTES' )
      } 
	  steps {
	    input('Do you want to proceed?')
	  }
	}
    stage('Openstack_tf_deployment') {
      steps {
        withCredentials([usernamePassword(credentialsId: "$Credentials", usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        sh ''' 
          cp -r /terraform_state_file/aws_binary/terraform .terraform
          cp /terraform_state_file/aws_binary/terraform.lock.hcl .terraform.lock.hcl        
          terraform init
          terraform apply -var Environment=$Environment -var aws_region=$aws_region -auto-approve -state=/terraform_state_file/$Environment/terraform.tfstate
        '''
        }
      }
    }
  }
    post {
      always {
        cleanWs()
      }
    }
}
