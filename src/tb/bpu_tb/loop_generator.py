outer_addr = 10
outer_times = 20
inner_addr = 80
inner_times = 3
body_addr = 24

with open("addresses.txt", "w") as addr_file, \
        open("resolutions.txt", "w") as res_file:
    for _ in range(outer_times):
        addr_file.write(f"{outer_addr}\n")
        res_file.write(f"{outer_addr} {inner_addr} 1\n")

        for _ in range(inner_times):
            addr_file.write(f"{inner_addr}\n")
            res_file.write(f"{inner_addr} {body_addr} 1\n")

        addr_file.write(f"{inner_addr}\n")
        res_file.write(f"{inner_addr} 0 0\n")

    addr_file.write(f"{outer_addr}\n")
    res_file.write(f"{outer_addr} 0 0\n")
