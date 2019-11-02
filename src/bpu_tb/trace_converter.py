import sys

with open(sys.argv[1], "r") as trace, \
        open("trace_char.txt", "w") as out1, \
        open("trace_bool.txt", "w") as out2:
    for line in trace:
        fields = line.split()
        taken = 0
        if fields[1] == 'T':
            taken = 1

        out1.write(f"{int(fields[0]):x} {fields[1]}\n")
        out2.write(f"{int(fields[0]):x} {taken}\n")
