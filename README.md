
# DevOps Diagnostic CLI

A lightweight Bash command-line application for displaying system information and checking TCP port connectivity. The project includes automated tests, Docker support, Docker Compose, and a GitHub Actions CI workflow.

## Features

- Display hostname, operating system, kernel version, and uptime.
- Check whether a TCP port is reachable.
- Validate command arguments and port ranges.
- Run the application inside a Docker container.
- Automatically lint, test, and build through GitHub Actions.

## Project Structure

```text
.
├── app/
│   └── app.sh
├── scripts/
│   ├── build.sh
│   └── lint.sh
├── tests/
│   └── test.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── .dockerignore
├── Dockerfile
├── compose.yaml
└── README.md
```

## Requirements

- Bash
- Docker
- Docker Compose (for Compose commands)

## Usage

Display help:

```bash
./app/app.sh help
```

Display system information:

```bash
./app/app.sh system-info
```

Check a TCP port:

```bash
./app/app.sh check-port localhost 22
```

The port check returns exit code `0` if the port is reachable, `1` if it is unreachable, and `2` for invalid arguments.

## Testing

Check shell script syntax:

```bash
./scripts/lint.sh
```

Run application tests:

```bash
./tests/test.sh
```

Build the Docker image:

```bash
./scripts/build.sh
```

Run the application in Docker:

```bash
docker run --rm student-devops-ci-grader help
docker run --rm student-devops-ci-grader system-info
```

Validate the Compose configuration:

```bash
docker compose config -q
```

## Docker Compose

Run the help command through Docker Compose:

```bash
docker compose run --rm diagnostic-cli help
```

## Continuous Integration

The GitHub Actions workflow at `.github/workflows/ci.yml` runs on pushes and pull requests.

It contains three jobs:
- **validate:** Checks Bash syntax in the application, scripts, and tests.
- **test:** Runs the automated application tests after validation succeeds.
- **docker:** Builds the Docker image and tests the help, system-info, and invalid-command behavior.

The jobs run in sequence: `validate` → `test` → `docker`. Each dependent job starts only after its required preceding job succeeds.

## Assumptions and Limitations

- The application targets Bash-compatible Linux environments.
- Port checks require network access to the specified host and port.
- An unreachable port is reported as a connectivity result, not necessarily proof that the service is permanently unavailable.
