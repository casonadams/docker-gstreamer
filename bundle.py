import subprocess
import sys
import json

shared_objects = {}

def get_shared_objects(file_location):
    print("Getting shared objects for", file_location)
    # get shared objects for lib or bin
    cmd = ["ldd", file_location]
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
            file_location = f[0].strip()
            if 'arm-linux-gnueabihf' in file_location:
                shared_objects[file_location] = file_location.replace("/arm-linux-gnueabihf", "").strip()
            else:
                shared_objects[file_location] = system_file_location

            # print(json.dumps(shared_objects, indent=2))

# get bin files and so's for bins
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
root_dirs.add("usr")
bin_prefix = "/usr/bin/"

for bin in bin_files:
    subprocess.call(["cp", bin_prefix+bin, "usr/bin/"])
    get_shared_objects(bin_prefix+bin)

# get so file and so's for each
so_files = [
        "/usr/lib/gstreamer-1.0/libgstrtsp.so",
        "/usr/lib/gstreamer-1.0/libgstpulseaudio.so",
        "/usr/lib/gstreamer-1.0/libgstmpg123.so",
        "/usr/lib/gstreamer-1.0/libgsttheora.so",
        "/usr/lib/gstreamer-1.0/libgstspeex.so",
        "/usr/lib/gstreamer-1.0/libgstdtls.so",
        "/usr/lib/gstreamer-1.0/libgsthls.so",
        "/usr/lib/gstreamer-1.0/libgstasf.so",
        "/usr/lib/gstreamer-1.0/libgstsoup.so",
        "/usr/lib/gstreamer-1.0/libgstvorbis.so",
        "/usr/lib/gstreamer-1.0/libgstaudiovisualizers.so",
        "/usr/lib/gstreamer-1.0/libgstshout2.so",
        "/usr/lib/gstreamer-1.0/libgstvideoparsersbad.so",
        "/usr/lib/gstreamer-1.0/libgstlame.so",
        "/usr/lib/gstreamer-1.0/libgstdashdemux.so",
        "/usr/lib/gstreamer-1.0/libgstwavparse.so",
        "/usr/lib/gstreamer-1.0/libgstsmoothstreaming.so",
        "/usr/lib/gstreamer-1.0/libgstapp.so",
        "/usr/lib/gstreamer-1.0/libgstaudiofx.so",
        "/usr/lib/gstreamer-1.0/libgstvideo4linux2.so",
        "/usr/lib/gstreamer-1.0/libgstmpegtsmux.so",
        "/usr/lib/gstreamer-1.0/libgstavi.so",
        "/usr/lib/gstreamer-1.0/libgstisomp4.so",
        "/usr/lib/gstreamer-1.0/libgstcamerabin.so",
        "/usr/lib/gstreamer-1.0/libgstspectrum.so",
        "/usr/lib/gstreamer-1.0/libgstsdpelem.so",
        "/usr/lib/gstreamer-1.0/libgstdvb.so",
        "/usr/lib/gstreamer-1.0/libgstogg.so",
        "/usr/lib/gstreamer-1.0/libgstmatroska.so",
        "/usr/lib/gstreamer-1.0/libgstmpegtsdemux.so",
        "/usr/lib/gstreamer-1.0/libgstsiren.so"
]

for line in so_files:
    get_shared_objects(line)

# create staging dir and populate files
tar_string = "tar czvf bundle.tar.gz"

root_dirs = set()

for key, value in shared_objects.items():
    directory = value.split("/")
    del directory[-1]
    temp_directory = ""
    for file in directory:
        temp_directory += file + "/"
    temp_directory = temp_directory[1:]
    root_dirs.add(temp_directory)
    subprocess.call(["mkdir", "-p", temp_directory])
    local_value = value[1:]
    subprocess.call(["cp", key, local_value])

subprocess.call(["mkdir", "-p", "usr/lib/gstreamer-1.0/"])

# copy all lib/gstreamer-1.0 files to staging
cmd = ["ls", "/usr/lib/gstreamer-1.0/"]
p = subprocess.check_output(
        cmd,
        stderr=subprocess.STDOUT,
        universal_newlines=True
    )
output = p.split("\n")

for file in output:
    subprocess.call(["cp", "/usr/lib/gstreamer-1.0/" + file, "usr/lib/gstreamer-1.0/"])

# tar up staging
cmd = ["tar", "czf", "bundle.tar.gz", "usr", "lib"]
subprocess.call(cmd)

# clean up
clean_up_call = ["rm", "-rf", "usr", "lib"]
subprocess.call(clean_up_call)

print("tar xzvfkp bundle.tar.gz")
