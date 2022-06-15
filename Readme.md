# Lombiq Github Actions



## About

Some common Github Actions shared between Lombiq projects, e.g. to publish packages to NuGet. There workflows can be invoked through the `call-build-workflow` step from any other repository's workflow.


## Documentation

To add the workflows to a project create a folder in the root of the repository that will call them, e.g. _.github/workflows/build.yml_ and/or _.github/workflows/publish.yml_. Things to keep in mind:

- If you have multiple projects in the repository or if the project you want to build is in a subfolder then add a solution to the root of the repository that references all projects you want to build.
- References to projects (`<ProjectReference>` elements) not in the repository won't work, these need to be changed to package references (`<PackageReference>` elements). Make the conditional based on `$(NuGetBuild)`. See the [Helpful Extensions project file](https://github.com/Lombiq/Helpful-Extensions/blob/dev/Lombiq.HelpfulExtensions.csproj) for an example. References to projects in the repository will work and those projects, if configured with the proper metadata, will be published together, with dependencies retained among the packages too.
- Projects building client-side assets with [Gulp Extensions](https://github.com/Lombiq/Gulp-Extensions) won't work during such builds. Until [we fix this](https://github.com/Lombiq/Open-Source-Orchard-Core-Extensions/issues/48), you have to commit the *wwwroot* folder to the repository, and add the same conditional to the Gulp and NPM Import elements too ([example](https://github.com/Lombiq/Orchard-Data-Tables/blob/58458b5d6381c71c094cb8d960e12b15a59f62d7/Lombiq.DataTables/Lombiq.DataTables.csproj#L33-L35)).

### NuGet publish workflow

Builds the project with the .NET SDK and publishes it as a NuGet package to the configured NuGet feed. Example _publish.yml_:

```yaml
name: Publish to NuGet

on:
  push:
    tags:
      - v*

jobs:
  call-publish-workflow:
    uses: Lombiq/GitHub-Actions/.github/workflows/publish.yml@dev
    secrets:
      apikey: ${{ secrets.DEFAULT_NUGET_PUBLISH_API_KEY }}
```

The _publish.yml_ workflow is triggered on a tag pushed to any branch with the prefix `v` and should contain a [valid version number](https://docs.microsoft.com/en-us/nuget/concepts/package-versioning#version-basics), e.g. `v1.0.1`, which will be extracted and used to version the NuGet packages produced.

It takes one non-optional secret parameter, `apikey`, the organization API key for pushing to NuGet, and two optional parameters, `source` and `verbosity`. E.g.:

```yaml
jobs:
  call-publish-workflow:
    uses: Lombiq/GitHub-Actions/.github/workflows/publish.yml@dev
    with:
      source: https://nuget.cloudsmith.io/lombiq/open-source-orchard-core-extensions/v3/index.json
      verbosity: detailed
    secrets:
      apikey: ${{ secrets.CLOUDSMITH_NUGET_PUBLISH_API_KEY }}
```

When `source` is not provided, it assumes a default value of pushing to the [Lombiq NuGet feed](https://www.nuget.org/profiles/Lombiq).

Valid values for `verbosity` are those defined by [MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference?view=vs-2022#:~:text=you%20can%20specify%20the%20following%20verbosity%20levels). The default value is `minimal`.

### Submodule verify workflow

Verifies if the submodule contains a JIRA style issue code (e.g. PROJ-123) and if a pull request exists for the parent module. Example _publish.yml_:

```yaml
name: Verify Pull Request

on:
  pull_request:

jobs:
  call-verify-workflow:
    uses: Lombiq/GitHub-Actions/.github/workflows/verify.yml@dev
    with:
      repo: Lombiq/Open-Source-Orchard-Core-Extensions
```

If this is for a submodule of [Lombiq's Open-Source Orchard Core Extensions](https://github.com/Lombiq/Open-Source-Orchard-Core-Extensions/), the `repo` input can be omitted, because the above is its default value. Otherwise, use your parent repository's address in the `{owner}/{repo_name}` format.

Refer to [Github Actions reusable workflows](https://docs.github.com/en/actions/learn-github-actions/reusing-workflows#overview) for more information.


## Contributing and support

Bug reports, feature requests, comments, questions, code contributions, and love letters are warmly welcome, please do so via GitHub issues and pull requests. Please adhere to our [open-source guidelines](https://lombiq.com/open-source-guidelines) while doing so.

This project is developed by [Lombiq Technologies](https://lombiq.com/). Commercial-grade support is available through Lombiq.
