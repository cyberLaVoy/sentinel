

## Spinning up

Install R

```bash
sudo apt install r-base-core
```

Install R package requirements

```bash
sudo Rscript requirements.R
```

Spin up app in background

```bash
nohup Rscript app.R &
```


## Setting what is monitored

```bash

sudo nvidia-xconfig --cool-bits=28

# Assuming a single GPU with of index 0
sudo nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=<value>"

# Set power limit value based on the result of this query
nvidia-smi -i 0 --format=csv --query-gpu=power.max_limit

sudo nvidia-smi -i 0 -pl <value>

```