
#!/bin/bash -e

nohup ./bin/chill run &
nohup ./bin/python api/src/api/app.py site.cfg &
