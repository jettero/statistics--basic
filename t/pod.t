#!/usr/bin/perl -w
use strict;
use Test::More;
no warnings;

# NOTE: please do not blame me for suggetions from this test.  Do not set
# TEST_AUTHOR and then tell me about it.  Use test at your own risk.
if ($ENV{TEST_AUTHOR} ne "author972") {
    plan( skip_all => 'Author test.  Set $ENV{TEST_AUTHOR} to true to run.');
}

eval "use Test::Pod 1.00";  ## no critic
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
all_pod_files_ok();
