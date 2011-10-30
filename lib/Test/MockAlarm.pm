package Test::MockAlarm;

use strict;
use warnings;

use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(set_alarm restore_alarm);

BEGIN {
    our $VERSION = '0.10';
    *CORE::GLOBAL::alarm = \&Test::MockAlarm::mocked_alarm;
}

my $_alarm;

sub mocked_alarm {
    if ( defined $_alarm && ref($_alarm) eq 'CODE' ) {
        return $_alarm->(shift);
    }
    else {
        return CORE::alarm(shift);
    }
}

sub set_alarm {
    $_alarm = shift;

    return;
}

sub restore_alarm {
    undef $_alarm;

    return;
}

1;

__END__

=head1 NAME

Test::MockAlarm - Replace the alarm function with whatever you want.

=head1 VERSION

version 0.10

=head1 SYNOPSIS

    # make this the first include
    use Test::MockAlarm qw(set_alarm restore_alarm);

    # trigger any alarm of 15 seconds
    set_alarm( sub { die 'alarm' if (shift == 15) } );

    # this will alarm
    foo();

    # reset it back to normal
    restore_alarm();

    # now this will not
    foo();

    # a simplified function with an alarm
    sub foo {
        eval {
            alarm(15);
            bar();     # i take less than 15 seconds
            alarm(0);
        };
        if ( $@ ) {
            print "The alarm was triggered.\n";
        }
    }

=head1 DESCRIPTION

C<Test::MockAlarm> is a simple interface that lets you replace perl's built-in C<alarm()> function
with whatever you'd like, allowing you to trigger alarms to test your alarm handling.

=head1 SUBROUTINES/METHODS

=over 3

=item set_alarm

This will replace the built-in C<alarm()> with whatever you'd like. Almost always, this will look
something like this:

    set_alarm( sub { die 'alarm' if ( shift == 60 ) } );

From this point forward, any C<alarm(60)> will trigger.

=cut

=item restore_alarm

Once you've finished testing, you can return C<alarm()> back to normal with this.

    # fascinating abuse with alarm()
    
    restore_alarm();
    
    # it's back to normal

=cut

=item mocked_alarm

C<Test::MockAlarm> uses this to replace perl's internal C<alarm()>.

=cut

=back

=head1 DEPENDENCIES

None

=head1 BUGS AND LIMITATIONS

Having a series of alarms with identical timeouts, like the following, is something that would be
difficult to trigger with this module's current approach.

    while ($condition) {
        alarm($timeout);
        do_something();
        alarm(0);
    }

There may be bugs that exist and other alarm situations that this may not work in - so far it's
managed to work where I've needed it.

=head1 AUTHOR

Jeremy Jack < jeremy@rocketscientry.com >

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with
this module.

=cut
