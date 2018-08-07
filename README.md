#NAME
Geo::Coordinates::Ellipsoid -- details of ellipsoids and routines to manipulate them

#SYNOPSIS
use Geo::Coordinates::Ellipsoid

#DESCRIPTION

#EXAMPLES
A description of the available ellipsoids and sample usage of the
conversion routines follows

##Ellipsoids

The Ellipsoids available are as follows:

1 Airy
2 Australian National
3 Bessel 1841
4 Bessel 1841 Nambia
5 Clarke 1866
6 Clarke 1880
7 Everest
8 Fischer 1960 Mercury
9 Fischer 1968
10 GRS 1967
11 GRS 1980
12 Helmert 1906
13 Hough
14 International
15 Krassovsky
16 Modified Airy
17 Modified Everest
18 Modified Fischer 1960
19 South American 1969
20 WGS 60
21 WGS 66
22 WGS-72
23 WGS-84
24 Everest 1830 Malaysia
25 Everest 1956 India
26 Everest 1964 Malaysia and Singapore
27 Everest 1969 Malaysia
28 Everest Pakistan
29 Indonesian 1974
30 Arc 1950
31 NAD 27
32 NAD 83

##ellipsoid-names

The ellipsoids can be accessed using ellipsoid-names. To store these into
an array you could use

     my @names = ellipsoid-names;

##ellipsoid-info

Ellipsoids may be called either by name, or number. To return the
ellipsoid information, ( "official" name, equator radius and square
eccentricity) you can use ellipsoid-info and specify a name. The
specified name can be numeric (for compatibility reasons) or a
more-or-less exact name. Any text between parentheses will be ignored.

     my($name, $r, $sqecc) = ellipsoid-info 'wgs84';
     my($name, $r, $sqecc) = ellipsoid-info 'WGS 84';
     my($name, $r, $sqecc) = ellipsoid-info 'WGS-84';
     my($name, $r, $sqecc) = ellipsoid-info 'WGS-84 (new specs)';
     my($name, $r, $sqecc) = ellipsoid-info 23;

#AUTHOR
Kevin Pye, Kevin.Pye@gmail.com
Graham Crookham, grahamc@cpan.org

#THANKS
Thanks go to the following:

Mark Overmeer for the ellipsoid-info routines and code review.

#COPYRIGHT
Copyright (c) 2000,2002,2004,2007,2010,2013 by Graham Crookham. All rights reserved.
Copyright (c) 2018 by Kevin Pye. All rights reserved.

This package is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
