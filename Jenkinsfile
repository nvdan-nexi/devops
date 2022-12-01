pipeline {
    agent { dockerfile true }

    parameters {
        choice(
            name: 'BUILD',
            choices: ['Debug', 'Release'],
            description: 'Build variant type'
        )
    }

    stages {
        stage('Pre-setup') {
            steps {
                echo 'Cleaning cache and build'
                sh "./gradlew clean"
            }
        }
        stage('Run Tests') {
            steps {
                echo 'Running Tests'
                sh "./gradlew test"
            }
        }
        stage('Build Source Code') {
            steps {
                echo 'Build Source Code as '+ params.BUILD
                script {
                    switch(params.BUILD) {
                        case "Debug": sh "./gradlew assembleDebug"; break
                        case "Release": sh "./gradlew assembleRelease"; break
                    }
                }
            }
        }
    }
}