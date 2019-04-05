#!/usr/bin/env python

#
# Usage:
#   Run the tests, putting the results in a file:
#   $ eus run-tests.l > result
#   Update the REPORT.org file with the most recent passing/non-passing test info by running:
#   $ ./update-report.py result
#


import sys

if len(sys.argv) != 2:
    print("Usage: $ ./update-report.py result-file")
    exit(0)

test_file   = open(sys.argv[1], "r")
org_file    = open("REPORT.org", "r+")
org_content = org_file.readlines()

for line1 in test_file:
    line1 = "deftest " + line1
    for i in range(0, len(org_content)):
        len1  = len(line1)
        lenoc = len(org_content[i])
        if (line1 in org_content[i]) or (line1[0:-1] + " " in org_content[i]):
            org_content[i] = org_content[i][0:5] + 'X' + org_content[i][6:]


org_content = "".join(org_content)

org_file.seek(0)
org_file.write(org_content)
org_file.close()
