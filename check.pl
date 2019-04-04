#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;

my ($file, $fh, $domain, $ua, $response, $string, $filehandler, $url, $email);
$file = 'list.txt';
open($fh, $file) or die "Could not open file '$file' $!";
while ($domain = <$fh>) {
        chomp $domain;
        $url = "http://whois.nic.ir/?name=" . $domain;
        $ua = LWP::UserAgent->new;
        $response = $ua->get( $url );
        $string = $response->content;
        if ($string =~ '\<pre\>\n\<\/pre\>') {
                open(my $filehandler, '>>', 'result.txt');
                print $filehandler $domain . ", Free\n";
                close $filehandler;
        }
        elsif ($string =~ 'ascii') {
                $email = $& if $string =~ '[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+';
                open(my $filehandler, '>>', 'result.txt');
                print $filehandler $domain . ", " . $email . "\n";
                close $filehandler;
        }
        else {
                open(my $filehandler, '>>', 'result.txt');
                print $filehandler $domain . ", Free\n";
                close $filehandler;
        }
        sleep(10)
}