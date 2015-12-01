# appliedSSH
Applied SSH Executer - Execute commands in batch hosts

### Example Files And Directories
- run.config
- playbooks/
- password
- ssh_config

### Running
##### NOTE: First chdir to the path where appliedSSH.sh exists i.e. root of this git clone before continuing
./applied playbooks/uptime [host1] [host2] [host3] [host4]


### Structure of Playbook
- Each Task is group of 2 lines
    - First line  : Description of Task
    - Second line : command line to execute remotely
- __No other lines including empty or commented lines are yet supported__
