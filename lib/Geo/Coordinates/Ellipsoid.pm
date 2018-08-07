use v6;

# Based on Geo::Coordinates::Ellipsoid.

module Geo::Coordinates::Ellipsoid {

   constant \deg2rad =   π / 180;
   constant \rad2deg = 180 /   π;
   
   # remove all markup from an ellipsoid name, to increase the chance
   # that a match is found.
   sub cleanup-name(Str $copy is copy) is export {
       $copy .= lc;
       $copy ~~ s:g/ \( <-[)]>* \) //;   # remove text between parentheses
       $copy ~~ s:g/ <[\s-]> //;         # no blanks or dashes
       $copy;
   }
   
   # Ellipsoid array (name,equatorial radius,square of eccentricity)
   # Same data also as hash with key eq name (in variations)
   
  class Ellipsoid {
    has $.name;
    has $.radius;
    has $.eccentricity;

    method create($name, $radius, $eccentricity) {
      Ellipsoid.new(name => $name, radius => $radius.Num, eccentricity => $eccentricity.Num);
    }
  }

  my @Ellipsoid;
  my %Ellipsoid;
   
  BEGIN {  # Initialize this before other modules get a chance
    @Ellipsoid = (
      Ellipsoid.create("Airy",                                6377563,     0.006670540),
      Ellipsoid.create("Australian National",                 6378160,     0.006694542),
      Ellipsoid.create("Bessel 1841",                         6377397,     0.006674372),
      Ellipsoid.create("Bessel 1841 Nambia",                  6377484,     0.006674372),
      Ellipsoid.create("Clarke 1866",                         6378206,     0.006768658),
      Ellipsoid.create("Clarke 1880",                         6378249,     0.006803511),
      Ellipsoid.create("Everest 1830 India",                  6377276,     0.006637847),
      Ellipsoid.create("Fischer 1960 Mercury",                6378166,     0.006693422),
      Ellipsoid.create("Fischer 1968",                        6378150,     0.006693422),
      Ellipsoid.create("GRS 1967",                            6378160,     0.006694605),
      Ellipsoid.create("GRS 1980",                            6378137,     0.006694380),
      Ellipsoid.create("Helmert 1906",                        6378200,     0.006693422),
      Ellipsoid.create("Hough",                               6378270,     0.006722670),
      Ellipsoid.create("International",                       6378388,     0.006722670),
      Ellipsoid.create("Krassovsky",                          6378245,     0.006693422),
      Ellipsoid.create("Modified Airy",                       6377340,     0.006670540),
      Ellipsoid.create("Modified Everest",                    6377304,     0.006637847),
      Ellipsoid.create("Modified Fischer 1960",               6378155,     0.006693422),
      Ellipsoid.create("South American 1969",                 6378160,     0.006694542),
      Ellipsoid.create("WGS 60",                              6378165,     0.006693422),
      Ellipsoid.create("WGS 66",                              6378145,     0.006694542),
      Ellipsoid.create("WGS-72",                              6378135,     0.006694318),
      Ellipsoid.create("WGS-84",                              6378137,     0.00669438 ),
      Ellipsoid.create("Everest 1830 Malaysia",               6377299,     0.006637847),
      Ellipsoid.create("Everest 1956 India",                  6377301,     0.006637847),
      Ellipsoid.create("Everest 1964 Malaysia and Singapore", 6377304,     0.006637847),
      Ellipsoid.create("Everest 1969 Malaysia",               6377296,     0.006637847),
      Ellipsoid.create("Everest Pakistan",                    6377296,     0.006637534),
      Ellipsoid.create("Indonesian 1974",                     6378160,     0.006694609),
      Ellipsoid.create("Arc 1950",                            6378249.145, 0.006803481),
      Ellipsoid.create("NAD 27",                              6378206.4,   0.006768658),
      Ellipsoid.create("NAD 83",                              6378137,     0.006694384),
    );

  # calc ecc  as  
  # a = semi major axis
  # b = semi minor axis
  # e^2 = (a^2-b^2)/a^2	
  # For clarke 1880 (Arc1950) a=6378249.145 b=6356514.966398753
  # e^2 (40682062155693.23 - 40405282518051.34) / 40682062155693.23
  # e^2 = 0.0068034810178165


    for @Ellipsoid -> $el {
        %Ellipsoid{$el.name} = $el;
        %Ellipsoid{cleanup-name $el.name} = $el;
    }

  }

  # Returns all pre-defined ellipsoid names, sorted alphabetically
  sub ellipsoid-names() is export {
      @Ellipsoid ==> map { .name };
  }

  # Returns "official" name, equator radius and square eccentricity
  # The specified name can be numeric (for compatibility reasons) or
  # a more-or-less exact name
  # Examples:   my($name, $r, $sqecc) = ellipsoid-info 'wgs84';
  #             my($name, $r, $sqecc) = ellipsoid-info 'WGS 84';
  #             my($name, $r, $sqecc) = ellipsoid-info 'WGS-84';
  #             my($name, $r, $sqecc) = ellipsoid-info 'WGS-84 (new specs)';
  #             my($name, $r, $sqecc) = ellipsoid-info 22;

  sub ellipsoid-info(Str $id) is export {
     %Ellipsoid{$id} // %Ellipsoid{cleanup-name $id};
  }

# Do we want this here"
  proto sub set-ellipse(|) is export { * }

  multi sub set-ellipse(Str $name) {
    my $el = ellipsoid-info($name);
    fail "Unknown ellipsoid $name" unless $el.defined;
    $eccentricity = $el.eccentricity;
    $radius       = $el.radius;
  }

  multi sub set-ellipse($new-radius, $new-eccentricity) {
    $radius = $new-radius;
    $eccentricity = $new-eccentricity;
  }
} # end module

=begin pod
=head1 NAME

Geo::Coordinates::Ellipsoid - Perl extension for Latitude Longitude conversions.

=head1 SYNOPSIS

use Geo::Coordinates::Ellipsoid;

my @ellipsoids=ellipsoid-names;

my($name, $r, $sqecc) = |ellipsoid-info 'WGS-84';

=head1 DESCRIPTION

=head1 EXAMPLES

A description of the available ellipsoids and sample usage of the conversion routines follows

=head2 Ellipsoids

The Ellipsoids available are as follows:

=item 1 Airy

=item 2 Australian National

=item 3 Bessel 1841

=item 4 Bessel 1841 (Nambia)

=item 5 Clarke 1866

=item 6 Clarke 1880

=item 7 Everest 1830 (India)

=item 8 Fischer 1960 (Mercury)

=item 9 Fischer 1968

=item 10 GRS 1967

=item 11 GRS 1980

=item 12 Helmert 1906

=item 13 Hough

=item 14 International

=item 15 Krassovsky

=item 16 Modified Airy

=item 17 Modified Everest

=item 18 Modified Fischer 1960

=item 19 South American 1969

=item 20 WGS 60

=item 21 WGS 66

=item 22 WGS-72

=item 23 WGS-84

=item 24 Everest 1830 (Malaysia)

=item 25 Everest 1956 (India)

=item 26 Everest 1964 (Malaysia and Singapore)

=item 27 Everest 1969 (Malaysia)

=item 28 Everest (Pakistan)

=item 29 Indonesian 1974

=item 30 Arc 1950

=item 31 NAD 27

=item 32 NAD 83

=head2 ellipsoid-names

The ellipsoids can be accessed using C<ellipsoid-names>. To store these into an array you could use 

     my @names = ellipsoid-names;

=head2 ellipsoid-info

Ellipsoids may be called either by name, or number. To return the ellipsoid information,
( "official" name, equator radius and square eccentricity)
you can use C<ellipsoid-info> and specify a name. The specified name can be numeric
(for compatibility reasons) or a more-or-less exact name.
Any text between parentheses will be ignored.

     my($name, $r, $sqecc) = |ellipsoid-info 'wgs84';
     my($name, $r, $sqecc) = |ellipsoid-info 'WGS 84';
     my($name, $r, $sqecc) = |ellipsoid-info 'WGS-84';
     my($name, $r, $sqecc) = |ellipsoid-info 'WGS-84 (new specs)';
     my($name, $r, $sqecc) = |ellipsoid-info 23;

=head1 AUTHOR

Graham Crookham, grahamc@cpan.org

Kevin Pye, kjpye@cpan.org

=head1 THANKS

Thanks go to the following:

Mark Overmeer for the ellipsoid-info routines and code review.


=head1 COPYRIGHT

Copyright (c) 2000,2002,2004,2007,2010,2013 by Graham Crookham.  All rights reserved.

copyright (c) 2018 by Kevin Pye.
    
This package is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.             

=end pod
