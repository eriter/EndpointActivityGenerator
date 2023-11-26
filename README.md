# Endpoint Activity Generator

This is a framework for activity generation on macOS and Linux, intended for testing Endpoint Detection and Response (EDR) agents and ensuring they generate appropriate telemetry.

## To run:

Prerequisite: [Ruby](https://www.ruby-lang.org/en/downloads/), this application was developed on Ruby 3.2.2, and has not been tested for backwards compatibility.

`rb bin/generate_activity.rb` or make executable:

```
chmod +x bin/generate_activity.rb
bin/generate_activity.rb
```

## What we do and how we do it

We primarily generate endpoint activity with the Ruby standard library, particularly `Socket` and `File`, logging activity as we go to a YAML log in the output directory.

Some of our logged data is retrieved via platform-dependent commands such as `ps`: were we to strive for a more platform agnostic approach we could provide some support for windows systems by querying the Ruby config for the host OS and providing calls for similar process information in a Windows environment.

Configuration, for instance what process we start and where we perform both our file operations and logging, is currently implemented as constants set from a config file. Were we to continue developing this framework we might very well want to add support for command line arguments or even interactive prompting, depending on the usecase.

An advantage of writing this framework in Ruby is legibility and testability: I've included some example tests, for instance. A meaningful disadvantage is diminished portability: execution environments without a system Ruby install would need some measure of additional configuration/bootstrapping which is not present here.
