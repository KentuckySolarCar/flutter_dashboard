This directory contains the actual definitions of the different available dashboards. A 'dashboard' in this context 
represents a self-contained collection of widgets that fully take-over a display. So the screen embedded in the steering
wheel have a 'dashboard' here that defines how it looks and behaves internally. Likewise, the dash mounted display is 
represented by a 'dashboard' here as well as defining entirely how it looks.

Again, each dashboard fully defines a single display. Internally, a dashboard may have pages or tabs but that is outside
the scope of this module.

The intention is each dashboard should be stateless. Subject to change. WIP