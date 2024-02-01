
# Retocli

[![License](https://img.shields.io/github/license/MarcOrfilaCarreras/retocli?style=flat)](https://github.com/MarcOrfilaCarreras/retocli) ![Build](https://img.shields.io/github/actions/workflow/status/MarcOrfilaCarreras/retocli/push.yml?branch=master&label=build&style=flat) ![Last commit](https://img.shields.io/github/last-commit/MarcOrfilaCarreras/retocli?style=flat)

Retocli is a command-line interface (CLI) tool that enables users to interact with the [Acepta El Reto](https://aceptaelreto.com) platform directly from their terminal. Acepta El Reto is a Spanish website that hosts programming challenges and problems for enthusiasts and learners alike.

## Features

- Log in to the AceptaElReto system using your credentials.
- View your user profile and profiles of other users using their ID or username.
- Submit results to the platform for evaluation and retrieve results for a specific problem by its ID or the latest attempts for all problems.


## Installation

### Precompiled Binary

You can download a precompiled binary from the [Releases](https://github.com/MarcOrfilaCarreras/retocli/releases) page. Choose the appropriate binary for your operating system and architecture, then follow these steps:

- Download the binary to your local machine.

- Make the binary executable:
    ``` bash
    chmod +x retocli
    ```

- Move the binary to a directory in your system PATH (optional but recommended):
    ``` bash
    sudo mv aceptaelreto /usr/local/bin/
    ```

### Build from Source
Alternatively, you can build the CLI from the source code. Follow these steps:

- Clone the repository to your local machine:
    ``` bash
    git clone https://github.com/MarcOrfilaCarreras/retocli.git
    ```

- Navigate to the project directory:
    ``` bash
    cd retocli
    ```

- Build the CLI using the following command:
    ``` bash
    make build
    ```
## Usage

The CLI provides several commands for interacting with the system. Below are the available commands along with their respective usage and arguments:

### login
Log in to the system by providing valid credentials.

``` bash
retocli login [arguments]
```

Arguments:

- -h, --help: Show help message and exit.
- -u, --username: Specify the username for authentication.
- -p, --password: Specify the password for authentication.

### logout
Log out and terminate the current authenticated session.

``` bash
retocli logout [arguments]
```

Arguments:

- -h, --help: Show help message and exit.

### profile
View user profile information.

``` bash
retocli profile [arguments]
```

Arguments:

- -h, --help: Show help message and exit.
- -i, --id: Specify the ID of the user.
- -u, --username: Specify the username.

### results
Retrieve and send information about submissions.

``` bash
retocli results [arguments]
```

Arguments:

- -h, --help: Show help message and exit.
- -i, --id: Specify the ID of the challenge to retrieve results.
- -l, --language: Specify the programming language (Accepted values: JAVA, C, C++).
- -f, --file: Specify the file to be sent for the challenge.
- -o, --operation: Specify a specific action to perform on the challenge (Accepted values: push, results).

## License

See the [LICENSE.md](LICENSE.md) file for details.