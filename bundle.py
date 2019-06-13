import subprocess
import sys

bin_files = [
        "gst-device-monitor-1.0",
        "gst-discoverer-1.0",
        "gst-inspect-1.0",
        "gst-launch-1.0",
        "gst-play-1.0",
        "gst-stats-1.0",
        "gst-typefind-1.0"
        ]

root_dirs = set()
subprocess.call(["mkdir", "-p", "usr/bin/"])
bin_prefix = "/usr/bin/"

for bin in bin_files:
    subprocess.call(["cp", bin_prefix+bin, "usr/bin/"])

    cmd = ["ldd", bin_prefix+bin]
    p = subprocess.check_output(
        cmd,
        stderr=subprocess.STDOUT,
        universal_newlines=True
    )
    output = p.split("\n")

    for line in output:
        files = line.split("=>")
        if len(files) > 1:
            f = files[1].split("(")
            system_file_location = f[0].strip()
            file_location = f[0]
            if 'arm-linux-gnueabihf' in file_location:
                file_location = file_location.replace("/arm-linux-gnueabihf", "").strip()
            directory = file_location.split("/")
            root_dirs.add(directory[1])
            if len(directory) > 3:
                temp_dir = directory[1] + "/" + directory[2]
                subprocess.call(["mkdir", "-p", temp_dir])
                subprocess.call(["cp", system_file_location, temp_dir+"/"])
            elif len(directory) > 2:
                temp_dir = directory[1]
                subprocess.call(["mkdir", "-p", temp_dir])
                subprocess.call(["cp", system_file_location, temp_dir+"/"])
            else:
                print("File didn't get copied:", file_location)
        else:
            print("File didn't get copied:", file_location)
            directory = file_location.split("/")
            temp_dir = directory[1]
            subprocess.call(["mkdir", "-p", temp_dir])
            subprocess.call(["cp", system_file_location, temp_dir+"/"])

subprocess.call(["mkdir", "-p", "usr/lib/gstreamer-1.0/"])

cmd = ["ls", "/usr/lib/gstreamer-1.0/"]
p = subprocess.check_output(
        cmd,
        stderr=subprocess.STDOUT,
        universal_newlines=True
    )
output = p.split("\n")

for file in output:
    subprocess.call(["cp", "/usr/lib/gstreamer-1.0/" + file, "usr/lib/gstreamer-1.0/"])

cmd = ["tar", "czf", "bundle.tar.gz"]
cmd += list(root_dirs)
subprocess.call(cmd)

clean_up_call = ["rm", "-rf"] + list(root_dirs)
subprocess.call(clean_up_call)

print("-"*24)
print("Uses this command in the root of the filesystem to copy bin files and shared objects")
print("="*24)
print("tar xzvfkp bundle.tar.gz")
print("="*24)

