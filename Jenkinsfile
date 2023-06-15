pipeline {
	triggers {
		// Polls SCM every five minutes, 24x7
        pollSCM('H/5 * * * *')
           }
    agent {label 'ssjnkap001.ucles.internal'}
    options { disableConcurrentBuilds() }
    stages {
        stage('Build + SonarQube analysis') {
			tools {
                jdk "jdk11" // the name you have given the JDK installation in Global Tool Configuration
                }
			environment {
				SONAR_SCANNER_OPTS = "-Xmx512m"
				}
            steps {
            withSonarQubeEnv('Pipeline SonarQube Prd') {
                bat "dotnet D:\\jenkins\\tools\\hudson.plugins.sonar.MsBuildSQRunnerInstallation\\Metrica_SonarScanner\\SonarScanner.MSBuild.dll begin /k:Metrica"
                bat '"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe" Metrica.build.proj /nodereuse:true /T:CodeAnalysisBuild /p:Config=Debug'
                bat "dotnet D:\\jenkins\\tools\\hudson.plugins.sonar.MsBuildSQRunnerInstallation\\Metrica_SonarScanner\\SonarScanner.MSBuild.dll end"
                }
            }
        }
    }
}