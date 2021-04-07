#!/usr/bin/perl

use strict;
use warnings;

use Try::Tiny;
use LWP::Parallel::UserAgent;
use HTTP::Request;

my $requests = [
    HTTP::Request->new('GET', 'http://www.yahoo.co.uk'),
    HTTP::Request->new('GET', 'http://www.google.co.uk'),
    HTTP::Request->new('GET', 'http://www.not-a-valid-url.com'),
];

my $ua = LWP::Parallel::UserAgent->new;
$ua->in_order(1);
$ua->timeout(2);
$ua->redirect(1);

foreach my $req (@$requests) {
    print "Registering " . $req->url ." ";
    try {
        (defined $ua->register($req))
        ?
        (print "[FAIL].\n")
        :
        (print "[OK].\n");
    }
    catch {
        print "[FAIL].\n";
    };
}

my $entries = $ua->wait;

foreach my $e (keys %$entries) {
    my $response = $entries->{$e}->response;
    print "Status for " .
          $response->request->url .
          ": [" .
          $response->code . "]\n";
}
