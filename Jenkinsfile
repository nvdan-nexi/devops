pipeline {
    agent any

    parameters {
        choice(
            name: 'BUILD',
            choices: ['Debug', 'Release'],
            description: 'Build variant type'
        )
    }

    stages {
        stage('Build Environment') {
            steps {
                echo 'Build android environment using docker'
                sh "./execute.sh build"
                sh "./execute.sh run"
            }
        }
        stage('Pre-setup') {
            steps {
                echo 'Cleaning cache and build'
                sh "./execute.sh command clean"
            }
        }
        stage('Run Tests') {
            steps {
                echo 'Running Tests'
                sh "./execute.sh command test"
            }
        }
        stage('Build Source Code') {
            steps {
                echo 'Build Source Code as '+ params.BUILD
                script {
                    switch(params.BUILD) {
                        case "Debug": sh "./execute.sh command assembleDebug"; break
                        case "Release": sh "./execute.sh command assembleRelease"; break
                    }
                    sh "./execute.sh extract";
                }
            }
        }
        stage('Distribution') {
            when {  expression { params.BUILD == 'Release' } }
            parallel {
              stage("Nexus") { steps { script { echo "Upload to Nexus" } } }
              stage("Maven") { steps { script { echo "Upload to Maven" } } }
              stage("Nuget") { steps { script { echo "Upload to Nuget" } } }
              stage("Node Package Manager") { steps { script { echo "Upload to Node Package Manager" } } }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'output/*.apk', onlyIfSuccessful: true

            script {
                echo 'Removing used resources'
                sh "./execute.sh remove";
            }
        }
    }
}