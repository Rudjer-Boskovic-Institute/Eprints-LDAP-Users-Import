#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
 
use Net::LDAP;
my $server = "ldap.example.com";
my $ldap = Net::LDAP->new( $server ) or die $@;

my $eprintsUsersString = `/usr/share/eprints3/bin/export irb user ListUserUsernames`;

my @eprintsUsers = split /\n/, $eprintsUsersString;

$ldap->bind;

my $base = "dc=example,dc=com";
my $attrs = [ 'uid', 'givenName', 'sn', 'mail', 'hrEduPersonPersistentID' ];
 
my $result = $ldap->search(
	base   => "$base",
	#filter => "sn=*",
	filter => "(&(objectClass=person)(objectClass=irbMailAccount))",
	attrs  => $attrs
);
 
die $result->error if $result->code;
 
my @entries = $result->entries;

my $entr;
my @ldapUsers;
foreach $entr ( @entries ) {
	my $rowLdap;
	# Output format for EPrints user import:
     	$rowLdap = $entr->get_value ( 'uid' ) . ":" . "user" . ":" . $entr->get_value ( 'mail' ) . ":" . $entr->get_value ( 'hrEduPersonPersistentID' ) . ":" . $entr->get_value ( 'givenName' ) . ":" . $entr->get_value ( 'sn' ) . "\n";
	push(@ldapUsers, $rowLdap);
} 
 
$ldap->unbind;

foreach my $ldapUser (@ldapUsers) {
	my $eprintsUserExists = 0;
	foreach my $eprintsUser (@eprintsUsers) {
		if ($ldapUser =~ /^$eprintsUser:/) {
			$eprintsUserExists = 1;
		}
	}
	if (!$eprintsUserExists) {
		print $ldapUser;
	}
}
