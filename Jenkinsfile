pipeline {
agent none
  parameters {
    choice(
        name: 'myParameter',
        choices: "Option1\nOption2",
        description: 'interesting stuff' )
	}
    stages {
        stage ('Speak') {
            when {
                // Only say hello if a "greeting" is requested
                expression { params.myParameter == 'Option1' }
            }
            steps {
                echo "Hello, bitwiseman!"
            }
        }
    }
}