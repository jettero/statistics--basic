#!/usr/bin/perl -w
use strict;
use Test::More;
use File::Spec;

# NOTE: please do not blame me for suggetions from this test.  Do not set
# TEST_AUTHOR and then tell me about it.  Use test at your own risk.
if ($ENV{TEST_AUTHOR} ne "author972") {
    plan( skip_all => 'Author test.  Set $ENV{TEST_AUTHOR} to true to run.');
}

eval { require Test::Perl::Critic; };

if ($@) {
    plan( skip_all => 'Test::Perl::Critic required for test.');
}

Test::Perl::Critic->import();
all_critic_ok();
