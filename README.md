# Endpoint Activity Generator

This is a framework for activity generation on macOS and Linux, intended for testing Endpoint Detection and Response (EDR) agents and ensuring they generate appropriate telemetry.

## To run:

Prerequisite: [Ruby](https://www.ruby-lang.org/en/downloads/), this application was developed on Ruby 3.2.2, and has not been tested for backwards compatibility.

`rb bin/generate_activity.rb` or make executable:

```
chmod +x bin/generate_activity.rb
bin/generate_activity.rb
```

List command line arg options via `rb bin/generate_activity.rb --help`

## What we do and how we do it

This generator primarily uses the Ruby standard library, especially `Socket` and `File`, to generate endpoint activity. The generated activity is logged in a YAML file in the (configurable) output directory.

Some of the logged data is obtained through platform-dependent commands like `ps`. For a more platform-agnostic approach, future enhancements could provide support for Windows systems by querying the Ruby config for the host OS and offering calls for similar process information in a Windows environment.

Configuration, such as the process to start and the locations for file operations and logging, is currently implemented as constants set from a config file. I've implemented some proof of concept work for overriding the default values from the config via command line flags. Keep in mind there's limited input sanitization or error handling for user input, so exercise caution when configuring the framework.

Writing this framework in Ruby provides advantages in terms of legibility and testability. Example tests have been included. However a notable disadvantage is diminished portability, as execution environments without a system Ruby install might require additional configuration/bootstrapping.

Note: While efforts are made to log errors related to permissions and access, this framework assumes it operates in a context where relevant permissions exist to start processes, perform various file operations, and create a network connection on an arbitrary port.
