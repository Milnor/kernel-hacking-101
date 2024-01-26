# Notes on **LFD103** - A Beginner's Guide to Linux Kernel Development

## Introduction to Linux Kernel Development Process
* *Patches* - small, incremental changes that add new features, make enhancements, and fix bugs
* No set date, but new releases come out every 10 to 11 weeks
* Releases are time-based, not feature-based
    - releases are not held up for features

### Release Cycle
* Linus releases a new kernel and opens a 2-week merge window
    - pulls code from subsystem maintainers for next release
    - 10k+ patches get pulled into his tree
    - at the end he releases  *release candidate 1*, i.e. *rc1*
        * Then it is bug fixes-only until everything is resolved
* New cycle begins with 3-week *quiet period*

### Types of Kernel Releases
* **Release Candidate (RC)**
    - used for testing new features in the mainline
    - tested for bugs and regressions
* **Stable**
    - bug fix-only releases, get backported
    - released, on average, once a week
* **Long-term**
    - stable releases selected for long-term maintenance to provide critical bug fixes
    - allow multiple vendors to collaborate on a release they plan to maintain for a long time

### Kernel Trees
* Mainline - maintained by Linus Torvalds
* Stable - maintained by Greg Kroah-Hartman, consists of stable release branches
* `linux-next` - integration tree maintained by Stephen Rothwell, catches merge conflicts

### Subsystem Maintainers
* resume notes here...


## References
* Shuah Khan. [LFD103](https://trainingportal.linuxfoundation.org/learn/course/a-beginners-guide-to-linux-kernel-development-lfd103/), The Linux Foundation.
