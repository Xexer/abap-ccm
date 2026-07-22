# Clean Core Measurement

Content:
- [General](#general)
- [Installation](#installation)
- [Configuration](#configuration)

## General

### Introduction

Do you want to track Clean Core metrics and view your KPIs for all systems at a glance? The CCM project provides you with a dashboard and various documentation tools to track your findings. The tool should run on the central ATC to enable process automation and easy access.

### Features

The following features are currently available, and some are already planned for upcoming versions:

- Dashboard with KPI (Level A to D, Key User objects, Scores)
- Documentation
- Cluster (Product, Team, Group, Company) und Assignment
- Detailed Messages, APIs and Objects
- Statistic over different clusters
- Import ATC data for calculation
- Custom KPI with Exemptions and Documentations *[Planned]*
- KPI and overview for Modifications *[Planned]*
- Diagram for Trend per system *[Planned]*
- Different roles, like Admin, Viewer, Developer *[Planned]*
- Authorization per system *[Planned]*

### Material

- [Clean Core Measurement - Overview](https://software-heroes.com/en/blog/abap-cloud-ccm-overview)
- [CCM - Determination of Level A Objects](https://software-heroes.com/en/blog/abap-ccm-determination-of-level-a-objects)

## Installation

Here you find some information, how to install the project in your system. Currently, the installation process is somewhat more complex because the BSP applications are not synchronized using the abapGit plugin.

### ABAP sources

Use the abapGit plugin in your system to import the repository along with all its objects. Finally, perform a mass activation to ensure the objects are actively created in the system.

### Fiori Apps

Clone the application into Business Application Studio (BAS) or VS Code. Next, create a deployment configuration for your system, using the BSP application name as described below. The deployment target is the package ``ZBC_CCM_FIORI``, which you previously created using abapGit.

| App Name | BSP Name | GitHub Repo |
|---|---|---|
| CCM Area | ZBC_CCM_AREA | https://github.com/Xexer/zbcccmarea |
| CCM Assign | ZBC_CCM_ASSIGN | https://github.com/Xexer/zbcccmassign |
| CCM Checks | ZBC_CCM_CHECK | https://github.com/Xexer/zbcccmchecks |
| CCM Cluster | ZBC_CCM_CLUSTER | https://github.com/Xexer/zbcccmcluster |
| CCM Dashboard | ZBC_CCM_DASHBO | https://github.com/Xexer/zbcccmdashboard |
| CCM Document | ZBC_CCM_DOC | https://github.com/Xexer/zbcccmdocument |
| CCM Objects | ZBC_CCM_OBJECT | https://github.com/Xexer/zbcccmobjects |
| CCM Run | ZBC_CCM_RUN | https://github.com/Xexer/zbcccmrun |
| CCM Used APIs | ZBC_CCM_USEDAPI | https://github.com/Xexer/zbcccmusedapis |
| CCM Used Messages | ZBC_CCM_USEDMSG | https://github.com/Xexer/zbcccmusedmessage |

## Configuration

tbd
