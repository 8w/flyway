# Deb file build instructions

1. Download the latest commandline package from [the flyway site](https://flywaydb.org/documentation/commandline/#download-and-installation)
1. Extract its contents directly into the `flyway-commandline/built` directory (no subdir for "flyway-6.4.1" or whatever)
1. Switch into the `flyway-commandline` directory
1. Update debian/changelog *including the version* using `dch -i`
1. Run `debuild -us -uc -b`