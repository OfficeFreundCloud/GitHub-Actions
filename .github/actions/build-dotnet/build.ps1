﻿param ($Verbosity, $EnableCodeAnalysis)

if (Test-Path src/Utilities/Lombiq.Gulp.Extensions/Lombiq.Gulp.Extensions.csproj)
{
    Write-Output "Gulp Extensions found. Building it first because it requires it."
    dotnet build src/Utilities/Lombiq.Gulp.Extensions/Lombiq.Gulp.Extensions.csproj --configuration Release --verbosity $Verbosity
}

Write-Output "Building solution."

$buildSwitches = @(
    "--configuration",
    "Release",
    "-warnaserror",
    "-p:TreatWarningsAsErrors=true",
    "-p:RunAnalyzersDuringBuild=$EnableCodeAnalysis",
    "-nologo",
    "-consoleLoggerParameters:NoSummary",
    "-verbosity:$Verbosity"
)

dotnet build (Get-ChildItem *.sln).FullName @buildSwitches