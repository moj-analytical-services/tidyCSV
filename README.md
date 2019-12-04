# Overview

This package provides functions to convert published MoJ data into Tidy Data format. The functions have been set up specifically to accept current published formats. Any change in how these files are published is likely to result in the package functions not working.


# Available Functions

## probationCaseload

This function will run on a Probation Caseload file, published in Offender Management Statistics Quarterly. An example can be found in the file *caseloadq1.csv* in this zip file: https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/823450/CSVs.zip

It also adds geographic data and additional breakdowns using lookup files stored in /data.

## probationStarts

This function will run on a Probation Caseload file, published in Offender Management Statistics Quarterly. An example can be found in the file *starts-q2-2019.csv* in this zip file: https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/843365/CSVs.zip

It also adds geographic data and additional breakdowns using lookup files stored in /data.
