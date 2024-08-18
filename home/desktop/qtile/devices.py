import subprocess

hostname = subprocess.Popen("hostname", stdout=subprocess.PIPE ).communicate()[0]
hostname = hostname.strip()  # remove trailing newline
hostname = hostname.decode("utf-8")  # decode from type 'byte' to type 'str'
#?
default_layout = "mon"
