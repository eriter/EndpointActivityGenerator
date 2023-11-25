# Endpoint Activity Generator

This is a framework for activity generation on macOS and Linux, intended for testing Endpoint Detection and Response (EDR) agents and ensuring they generate appropriate telemetry.

We primarily generate endpoint activity with the Ruby standard library, particularly `Socket` and `File`, logging activity as we go to a JSON log in the output directory.

Some of our logged data is retrieved via platform-dependent commands including `ps`: were we to strive for a more platform agnostic approach we could provide some support for windows systems by querying the Ruby config for the host OS and providing calls for similar process information in a Windows environment.

Configuration, for instance what process we start and where we perform both our file operations and logging, is currently implemented as constants, configurable from the main script file. Were we to continue developing this framework we might expand to support command line arguments or a config file (YAML might be a good fit).

An advantage of writing this framework in Ruby is legibility and developer productivity: I've included some example tests, for instance. A meaningful disadvantage is diminished portability: execution environments without a sytem Ruby install would need some measure of additional configuration/bootstrapping which is not present here.
